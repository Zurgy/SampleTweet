This is some sample ObjectiveC code to download tweets for a given username from Twitter and display them using custom table cells.


Requires IOS 5 as makes uses of NSJSONSerialization.
Uses ASIHTTPRequest (BSD licensed) third-party networking code for network requests. This doesn't currently support ARC so compiler flags are necessary to use it as part of an ARC project.

N.B. This code for downloading the profile pic is sub-optimal in that it makes multiple requests to download the same picture.