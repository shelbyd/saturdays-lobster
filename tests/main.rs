extern crate saturdays_lobster;
use saturdays_lobster::query_executor::handle_query;

#[test]
fn test_echo() {
    assert_eq!(handle_query("foobar"), "raboof");
}
