/**
 * Copyright (c) 2017-present, Status Research and Development GmbH.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 *
 */

#include "desktopnotification.h"
#include "bridge.h"
#include "eventdispatcher.h"

#include <QDebug>

namespace {
struct RegisterQMLMetaType {
    RegisterQMLMetaType() {
        qRegisterMetaType<DesktopNotification*>();
    }
} registerMetaType;
} // namespace

class DesktopNotificationPrivate {
public:
    Bridge* bridge = nullptr;
};

DesktopNotification::DesktopNotification(QObject* parent) : QObject(parent), d_ptr(new DesktopNotificationPrivate) {
}

DesktopNotification::~DesktopNotification() {}

void DesktopNotification::setBridge(Bridge* bridge) {
    Q_D(DesktopNotification);
    d->bridge = bridge;
}

QString DesktopNotification::moduleName() {
    return "DesktopNotification";
}

QList<ModuleMethod*> DesktopNotification::methodsToExport() {
    return QList<ModuleMethod*>{};
}

QVariantMap DesktopNotification::constantsToExport() {
    return QVariantMap();
}

void DesktopNotification::sendNotification(double callbackId) {
    Q_D(DesktopNotification);
    qDebug() << "call of DesktopNotification::sendNotification(); !!!";
    d->bridge->invokePromiseCallback(callbackId, QVariantList{});
}