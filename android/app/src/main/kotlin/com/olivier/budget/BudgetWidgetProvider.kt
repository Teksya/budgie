package com.olivier.budget

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider

/// Home-screen widget showing the current "reste à vivre". Data is pushed from
/// Flutter via the home_widget shared preferences; tapping opens the app.
class BudgetWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences,
    ) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.budget_widget).apply {
                setTextViewText(
                    R.id.widget_amount,
                    widgetData.getString("remaining", "—"),
                )
                setTextViewText(
                    R.id.widget_label,
                    widgetData.getString("label", "Reste à vivre"),
                )
                val pendingIntent = HomeWidgetLaunchIntent.getActivity(
                    context,
                    MainActivity::class.java,
                )
                setOnClickPendingIntent(R.id.widget_root, pendingIntent)
            }
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}
