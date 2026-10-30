# The Postgres module is intentionally absent during teardown.
# Its SSM parameters no longer exist, so the configuration cannot load them.
# Resources already recorded in state are destroyed by the teardown workflow.
