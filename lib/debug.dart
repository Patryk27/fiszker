/// @todo describe
const DEBUG_MODE = true;

/// If enabled, the in-memory repositories are enabled over the actual database ones.
/// Useful for debugging purposes only.
const DEBUG_ENABLE_IN_MEMORY_REPOSITORIES = DEBUG_MODE && false;

/// If enabled, all BLoC events will be print()-ed to the standard output.
/// Useful for debugging purposes only.
const DEBUG_LOG_BLOC_EVENTS = DEBUG_MODE && true;

/// If enabled, all BLoC transitions will be print()-ed to the standard output.
/// Useful for debugging purposes only.
const DEBUG_LOG_BLOC_TRANSITIONS = DEBUG_MODE && true;

/// If enabled, all BLoC errors will be print()-ed to the standard output.
/// Useful for debugging purposes only.
const DEBUG_LOG_BLOC_ERRORS = DEBUG_MODE && true;
