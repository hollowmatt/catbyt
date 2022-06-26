load("render.star", "render")
load("http.star", "http")
load("encoding/base64.star", "base64")
load("cache.star", "cache")

STOCK_QUOTE_URL = "https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=IBM&apikey=demo"
ALPHA_KEY="&apikey=demo"
GOOG_SYMBOL="&GOOGL"
AMZN_SYMBOL="&AMZN"
PEL_SYMBOL="&PTON"
APL_SYMBOL="&AAPL"
MS_SYMBOL="&MSFT"

SYMBOL_B64 = base64.decode("""
iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAAXNSR0IArs4c6QAAAIxJREFUOE
9jZGBg+M+ABl6UMqMLgfkS3X8xxBmRDYBpxKYQpBObPNwAkCQujdhcCFMLNgCf5u8f9jBwCrhg
OB2mB6cBII3oANkguAEvSpn/ozsd2VZcbFiYMJJiALawoI0BIJsIhQFeLyA7lawwIMkAbOmAmF
igXjqA5QVcqRFbSkRWS73MhBxwpGRnAGAwmUGS9KHUAAAAAElFTkSuQmCC
""")



def main():
    rate_cached = cache.get("sym_rate")
    if rate_cached != None:
        print("Hit! Displaying cached data.")
        rate = int(rate_cached)
    else:
        print("Miss! Calling Alpha API.")
        full_url=STOCK_QUOTE_URL + GOOG_SYMBOL + ALPHA_KEY  
        rep = http.get(STOCK_QUOTE_URL)
        if rep.status_code != 200:
            fail("API request failed with status %d", rep.status_code)
        rate = rep.json()["Global Quote"]["05. price"]
        cache.set("sym_rate", str(int(float(rate))), ttl_seconds=240)

    return render.Root(
        child = render.Box(
            render.Row(
                expanded=True,
                main_align="space_evenly",
                cross_align="center",
                children = [
                    render.Image(src=SYMBOL_B64),
                    render.Text("GOOG: $%d" % rate),
                ],
            ),
        ),
    )