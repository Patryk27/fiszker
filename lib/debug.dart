/// If enabled, the in-memory repositories are enabled over the actual database ones - that is: all data will be lost
/// after application's restarted.
/// Useful for debugging purposes only.
const DEBUG_ENABLE_IN_MEMORY_REPOSITORIES = false;

/// If enabled, all BLoC events will be print()-ed to the standard output.
/// Useful for debugging purposes only.
const DEBUG_LOG_BLOC_EVENTS = false;

/// If enabled, all BLoC transitions will be print()-ed to the standard output.
/// Useful for debugging purposes only.
const DEBUG_LOG_BLOC_TRANSITIONS = false;

/// If enabled, all BLoC errors will be print()-ed to the standard output.
/// Useful for debugging purposes only.
const DEBUG_LOG_BLOC_ERRORS = true;
