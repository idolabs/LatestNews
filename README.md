# <img src="https://raw.github.com/idolabs/LatestNews/master/icon_ipad.png" alt="LatestNewsIcon"> Latest News (Mobil Haber)


## Overview

Mobil Haber is a visual RSS reader application designed for iOS devices. It retrieves data from popular Turkish News Agencies 
and News papers' RSS services.
This app is free of charge and ads-free in order to provide a better user experience.

<img src="https://raw.github.com/idolabs/LatestNews/master/screenshots/ipad_2.jpg" width="500" />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<img src="https://raw.github.com/idolabs/LatestNews/master/screenshots/ipad_1.jpg" width="281" />


## Features

 - Retrieve data from 30+ RSS services which provide images for each rss item
 - Show list of rss news for each source in a seperate horizontal table view
 - Group news sources accoring to their categories( economy, sports etc. ) and show them in a main table view
 - Parse reponse xmls of rss services in background threads using GCD dispatch queues, eliminate duplicate and no-image items
 - Use <a href="https://github.com/AFNetworking/AFNetworking">AFNetworking</a> for making asynchronous http requests 
 - Use <a href="https://github.com/rs/SDWebImage">SDWebImage</a> for caching images shown in main table view 
 - Open the link of a news item in a seperate UIWebView when an item is selected from the main table view
 - Retrieve rss sources list from a plist file stored in <a href="http://aws.amazon.com/s3/">Amazon S3</a>, cache the file in NSUserDefaults, fallback to local plist file if necessary

TODO: list other features...

## Support

support email: support@idolabs.com

## License

(The MIT License)

Copyright © 2012 Bahaddin Yasar and Inanc Sevinc

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.