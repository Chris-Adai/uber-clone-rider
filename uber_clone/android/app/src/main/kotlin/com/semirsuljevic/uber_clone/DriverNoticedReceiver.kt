package com.semirsuljevic.uber_clone

import android.app.NotificationManager
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

/**
 * this action button will just open the app with main activity
 * it has no actual purpose
 * in the future, it needs to message the driver that the rider
 * has spotted them
*/

class DriverNoticedReceiver:BroadcastReceiver() {

    override fun onReceive(context: Context?, intent: Intent?) {

        if( context == null || intent == null) {
            return;
        }

        val closeDrawer = Intent(Intent.ACTION_CLOSE_SYSTEM_DIALOGS);
        context.sendBroadcast(closeDrawer)

        val ns = Context.NOTIFICATION_SERVICE;
        val manager:NotificationManager = context.getSystemService(ns) as NotificationManager
        manager.cancel(intent.getIntExtra("notificationId", -1));

        val startIntent = Intent(context, MainActivity::class.java)
        startIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)

        context.startActivity(startIntent, null)

    }
}