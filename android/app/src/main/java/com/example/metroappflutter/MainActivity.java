package com.example.metroappflutter;

import android.app.Activity;
import android.content.IntentSender;

import androidx.annotation.NonNull;

import com.google.android.gms.common.api.ResolvableApiException;
import com.google.android.gms.location.LocationRequest;
import com.google.android.gms.location.LocationServices;
import com.google.android.gms.location.LocationSettingsRequest;
import com.google.android.gms.location.LocationSettingsResponse;
import com.google.android.gms.location.Priority;
import com.google.android.gms.location.SettingsClient;
import com.google.android.gms.tasks.Task;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {

    private static final String CHANNEL = "com.metroapp/location";
    private static final int REQUEST_CHECK_SETTINGS = 2001;

    private MethodChannel.Result _pendingResult;

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        new MethodChannel(
                flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL
        ).setMethodCallHandler((call, result) -> {
            if ("requestLocationService".equals(call.method)) {
                _pendingResult = result;
                _showLocationResolutionDialog();
            } else {
                result.notImplemented();
            }
        });
    }

    private void _showLocationResolutionDialog() {
        LocationRequest locationRequest = new LocationRequest.Builder(
                Priority.PRIORITY_HIGH_ACCURACY, 5000
        ).build();

        LocationSettingsRequest settingsRequest = new LocationSettingsRequest.Builder()
                .addLocationRequest(locationRequest)
                .setAlwaysShow(true) // keeps the dialog always visible (no "never" option)
                .build();

        SettingsClient client = LocationServices.getSettingsClient(this);
        Task<LocationSettingsResponse> task = client.checkLocationSettings(settingsRequest);

        task.addOnSuccessListener(this, response -> {
            // Location is already on
            if (_pendingResult != null) {
                _pendingResult.success(true);
                _pendingResult = null;
            }
        });

        task.addOnFailureListener(this, e -> {
            if (e instanceof ResolvableApiException) {
                // Show the native Google Play Services dialog
                try {
                    ((ResolvableApiException) e).startResolutionForResult(
                            this, REQUEST_CHECK_SETTINGS
                    );
                } catch (IntentSender.SendIntentException ignored) {
                    if (_pendingResult != null) {
                        _pendingResult.success(false);
                        _pendingResult = null;
                    }
                }
            } else {
                // Device doesn't support the resolution (rare)
                if (_pendingResult != null) {
                    _pendingResult.success(false);
                    _pendingResult = null;
                }
            }
        });
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, android.content.Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == REQUEST_CHECK_SETTINGS && _pendingResult != null) {
            _pendingResult.success(resultCode == Activity.RESULT_OK);
            _pendingResult = null;
        }
    }
}
