package com.clone.dodo.dodo_clone

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant
import com.yandex.mapkit.MapKitFactory

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        MapKitFactory.setApiKey("ab7376d7-bd45-4f89-9c30-a9e7b4dd7c9b")
        super.configureFlutterEngine(flutterEngine)
    }
}