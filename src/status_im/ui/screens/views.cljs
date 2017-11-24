(ns status-im.ui.screens.views
  (:require-macros [status-im.utils.views :refer [defview letsubs]])
  (:require [re-frame.core :refer [dispatch]]
            [status-im.components.react :refer [view modal]]
            [status-im.components.styles :as common-styles]
            [status-im.ui.screens.profile.views :refer [profile]]))

(defn validate-current-view
  [current-view signed-up?]
  (
    current-view
    :profile))

(enable-console-print!)
(print "-------------- MAIN - PROFILE ------------------")

(defview main []
  [view [profile]])
          
