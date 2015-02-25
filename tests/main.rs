extern crate saturdays_lobster;
use saturdays_lobster::query_executor::handle_query;

#[test]
fn test_ping() {
    assert_eq!(handle_query("ping"), "PONG");
}

#[test]
fn test_unknown_command() {
    assert_eq!(handle_query("afunriefn"), "unrecognized command \"afunriefn\"");
}
