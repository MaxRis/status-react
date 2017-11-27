(ns status-im.utils.slurp
  (:refer-clojure :exclude [slurp])
  (:require [clojure.string :as string]
            [hickory.core :as hickory]))

(defmacro slurp [file]
  (clojure.core/slurp file))

(defmacro slurp-bot [bot-name & files]
  (->> (concat files ["translations.js" "bot.js"])
       (map (fn [file-name]
              (try
                (clojure.core/slurp
                  (string/join "/" ["resources/js/bots" (name bot-name) file-name]))
                (catch Exception _ ""))))
       (apply str)))

(def svg-tags #{:g :rect :path :use :defs})

(defmacro slurp-svg [file]

  (let [svg (-> (clojure.core/slurp file)
                (string/replace #"[\n]\s*" ""))
        svg-hiccup (first (map hickory/as-hiccup (hickory/parse-fragment svg)))
        color (gensym "args")]
    `(fn [~color]
       ~(into []
          (clojure.walk/prewalk
            (fn [node]
              (if (svg-tags node)
                (if (= :use node)
                  (symbol "use-def")
                  (symbol (name node)))
                (if (vector? node)
                  (let [[k v] node]
                    (if (and (= :fill k) v)
                      [k color]
                      node))
                  node)))
            (rest (rest svg-hiccup)))))))