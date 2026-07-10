package com.olivier.budget

import io.flutter.embedding.android.FlutterFragmentActivity

// FlutterFragmentActivity, not FlutterActivity: local_auth shows the biometric
// prompt as a fragment and crashes without a FragmentActivity host.
class MainActivity : FlutterFragmentActivity()
