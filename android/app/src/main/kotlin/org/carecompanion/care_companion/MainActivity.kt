package org.carecompanion.care_companion

import android.os.Bundle
import android.view.WindowManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private fun setSecure(secure: Boolean) {
        if (secure) {
            window.addFlags(WindowManager.LayoutParams.FLAG_SECURE)
        } else {
            window.clearFlags(WindowManager.LayoutParams.FLAG_SECURE)
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // Privacy by default: hide health values from the recent-apps
        // thumbnail and block screenshots. The app turns this off when the
        // family switches "Hide the app in screenshots" off in Settings.
        setSecure(true)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "org.carecompanion/privacy")
            .setMethodCallHandler { call, result ->
                if (call.method == "setSecure") {
                    setSecure(call.arguments as? Boolean ?: true)
                    result.success(null)
                } else {
                    result.notImplemented()
                }
            }
    }
}
