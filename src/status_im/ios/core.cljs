(ns status-im.ios.core
  (:require [reagent.core :as reagent]
            [re-frame.core :refer [subscribe dispatch dispatch-sync]]
            [status-im.ui.screens.views :as views]
            [status-im.components.react :as react]
            [status-im.utils.platform :as platform]))

(defn app-root []

  (reagent/create-class
    {
     :component-did-mount (fn []
                            (if-not platform/desktop? ( .hide react/splash-screen)))
     :display-name "root"
     :reagent-render views/main}))

(defn init []
  (.registerComponent react/app-registry "StatusIm" #(reagent/reactify-component app-root))
  ;(dispatch-sync [:initialize-app])
  )
