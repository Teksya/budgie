package com.olivierd.budgie

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider

/// Home-screen widget showing the next unpaid charge. Data pushed from Flutter.
class BillWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences,
    ) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.bill_widget).apply {
                setTextViewText(
                    R.id.bill_name,
                    widgetData.getString("bill_name", "Aucune échéance"),
                )
                setTextViewText(R.id.bill_due, widgetData.getString("bill_due", ""))
                setOnClickPendingIntent(
                    R.id.bill_root,
                    HomeWidgetLaunchIntent.getActivity(context, MainActivity::class.java),
                )
            }
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}
