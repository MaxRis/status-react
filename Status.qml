
import QtQuick 2.4
import React 0.1 as React

Rectangle {
  id: root
  width: 640; height: 480;

  React.RootView {
    anchors.fill: parent

    moduleName: "StatusIm"
    codeLocation: "http://localhost:8081/index.ios.bundle?platform=ubuntu&dev=true"
  }
}
