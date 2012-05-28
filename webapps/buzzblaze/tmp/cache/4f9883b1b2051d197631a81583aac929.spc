a:4:{s:5:"child";a:1:{s:27:"http://www.w3.org/2005/Atom";a:1:{s:4:"feed";a:1:{i:0;a:6:{s:4:"data";s:16:"















";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:1:{s:27:"http://www.w3.org/2005/Atom";a:6:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:23:"Facebook Developer Blog";s:7:"attribs";a:1:{s:0:"";a:1:{s:4:"type";s:4:"text";}}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"updated";a:1:{i:0;a:5:{s:4:"data";s:20:"2011-02-18T16:00:00Z";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:2:"id";a:1:{i:0;a:5:{s:4:"data";s:45:"urn:uuid:6c306ca7-ff0b-4f7a-b371-92964eac0f14";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:0:"";s:7:"attribs";a:1:{s:0:"";a:3:{s:4:"href";s:40:"http://developers.facebook.com/blog/feed";s:3:"rel";s:9:"alternate";s:4:"type";s:9:"text/html";}}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:6:"author";a:1:{i:0;a:6:{s:4:"data";s:0:"";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:1:{s:27:"http://www.w3.org/2005/Atom";a:1:{s:4:"name";a:1:{i:0;a:5:{s:4:"data";s:8:"Facebook";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}}s:5:"entry";a:10:{i:0;a:6:{s:4:"data";s:6:"





";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:1:{s:27:"http://www.w3.org/2005/Atom";a:5:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:42:"Platform Updates: Operation Developer Love";s:7:"attribs";a:1:{s:0:"";a:1:{s:4:"type";s:4:"text";}}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"updated";a:1:{i:0;a:5:{s:4:"data";s:20:"2011-02-18T16:00:00Z";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:2:"id";a:1:{i:0;a:5:{s:4:"data";s:45:"urn:uuid:47dfbbd2-602e-4355-baaf-a583cd86fa03";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:0:"";s:7:"attribs";a:1:{s:0:"";a:3:{s:4:"href";s:44:"http://developers.facebook.com/blog/post/466";s:3:"rel";s:9:"alternate";s:4:"type";s:9:"text/html";}}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"content";a:1:{i:0;a:5:{s:4:"data";s:5004:"<div><img src="http://developers.facebook.com/attachment/odl_tall.png" style="float:right;margin-left:17px;margin-bottom:5px;" height="213" />

<p>
This week, we encouraged all apps to upgrade to <a href="https://developers.facebook.com/blog/post/464">Requests 2.0</a> so that as a developer, you only need to worry about one way of updating users about outstanding items in your app - send requests.
</p>

<p>
<b>Determine all apps owning a test user</b>
</p>
<p>
We previously announced that test accounts can be <a href="http://developers.facebook.com/blog/post/459">shared between apps</a>. We’ve now added the ability to retrieve all apps owning a test user:
</p>

<p>
<code>GET "TEST_USER_ID"/ownerapps</code>
</p>

<p>
It needs to be called with access token of one of the owner apps. Here’s a PHP example on creating the test user and retrieving all apps owning a test user:
</p>

<p>
<pre>
&lt;?php

  //owner_app_id will create the test user
  $owner_app_id = 'OWNER_APP_ID';
  $owner_app_secret = 'OWNER_APP_SECRET';

  $owner_token_url = "https://graph.facebook.com/oauth/access_token?" .
    "client_id=" . $owner_app_id .
    "&client_secret=" . $owner_app_secret .
    "&grant_type=client_credentials";

  $owner_access_token = file_get_contents($owner_token_url);

  //create test user
  $request_url ="https://graph.facebook.com/" .
    $owner_app_id .
    "/accounts/test-users?installed=true&permissions=read_stream&" .
    $owner_access_token . "&method=post";

  $result = file_get_contents($request_url);
  $obj = json_decode($result);
  $test_user_id = $obj->{'id'};

  //retrieve all apps owning a test user
  $request_url ="https://graph.facebook.com/" .
    $test_user_id . "/ownerapps&" .
    $owner_access_token;

  $result = file_get_contents($request_url);
  echo("owner apps= " . $result);

?>
</pre>
</p>

<p>
<b>Timestamp update on Dev Site pages</b>
</p>
<p>
We’ve added timestamps at the bottom left of pages on the Dev Site so that you’ll know when pages were last updated.
</p>
<p>
<img src="http://a3.sphotos.ak.fbcdn.net/hphotos-ak-ash1/182418_10150105885148553_19292868552_6359691_3925825_n.jpg" width="99%" style="border:1px solid #CCCCCC" />
</p>

<p>
<b>Limit on number of properties displayed for stream stories published via API</b>
</p>
<p>
We’ve put a limit to the <a href="http://developers.facebook.com/docs/guides/attachments/">number of key/value pairs</a> that will be <b>displayed</b> on stream story properties published via the API. You can continue to publish an unlimited amount of key/value pairs, but we will only display the first 3 key/value pairs on the News Feed.
</p>
<p>
<img src="http://developers.facebook.com/attachment/Screen%20shot%202011-02-18%20at%207.05.51%20PM.png" style="margin: 2px;" />
</p>

<p>
<b>Submitting great bug reports</b>
</p>
<p>
We have ramped up the number of people triaging bugs and have been able to touch a progressively larger number of bugs each week. When we have repro info from the start, it makes it so much easier for us to reproduce the bug ourselves and to get the bug into the pipeline to get fixed. We aggressively mark all bugs without proper reproduction steps as “needs repro”.
</p>

<p>
To ensure we can immediately understand and get to work on fixing the bug you’re reporting, here are some helpful tips:
<ul>
<li><a href="http://bugs.developers.facebook.net/query.cgi?format=specific">Check</a> if your bug has already been filed, so you can simply subscribe and comment with any relevant repro steps for your case.</li>
<li>Provide step-by-step instructions including URLs and/or code snippets that any Facebook developer could <b>easily</b> follow to reproduce the bug. 
Include any and all user IDs, Page IDs, app IDs, etc. that you use as well as an explanation of how you got any of the access tokens you’re using.</li>
<li>Include a screencast video or trace logs.</li>
</ul>
</p>

<p>
If you’re looking for a good example, <a href="http://www.krotscheck.net/demos/facebookLoginBug/index.php">check this out</a>. Please add a comment below if you have any thoughts or suggestions on what we can be doing better.
</p>

<p>
<b>Fixing Bugs</b><br />
<a href="http://bugs.developers.facebook.net/">Bugzilla</a> activity for the past 7 days:
<ul>
<li>129 new bugs were reported</li>
<li>63 bugs were reproducible and accepted (after duplicates removed)</li>
<li>15 bugs were fixed (13 previously reported bugs and 2 new bugs)</li>
<li>As of today, there are 4,141 open bugs in Bugzilla</li>
</ul>
</p>

<p>
<b>Forum Activity</b><br />
<a href="http://forum.developers.facebook.net/">Developer Forum</a> activity for the past 7 days:
<ul>
<li>363 New Topics Created</li>
<li>220 New Topics received a reply</li>
<li>Of those 220, 66 were replied to by a Facebook employee</li>
<li>Of those 220, 135 were replied to by a community moderator</li>
</ul>
</p>

<p>
<i>Ben, a Platform Engineer, is hoping timestamps on the Dev Site are helpful. Transparency FTW!</i></p></div>";s:7:"attribs";a:2:{s:0:"";a:1:{s:4:"type";s:9:"text/html";}s:36:"http://www.w3.org/XML/1998/namespace";a:1:{s:4:"lang";s:2:"en";}}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:2:"en";}}}}}i:1;a:6:{s:4:"data";s:6:"





";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:1:{s:27:"http://www.w3.org/2005/Atom";a:5:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:62:"How to publish updates to people who like your Open Graph Page";s:7:"attribs";a:1:{s:0:"";a:1:{s:4:"type";s:4:"text";}}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"updated";a:1:{i:0;a:5:{s:4:"data";s:20:"2011-02-18T14:30:00Z";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:2:"id";a:1:{i:0;a:5:{s:4:"data";s:45:"urn:uuid:ba83e6a3-b25d-4b00-9942-0c7b486dbfaa";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:0:"";s:7:"attribs";a:1:{s:0:"";a:3:{s:4:"href";s:44:"http://developers.facebook.com/blog/post/465";s:3:"rel";s:9:"alternate";s:4:"type";s:9:"text/html";}}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"content";a:1:{i:0;a:5:{s:4:"data";s:3166:"<div><p>
As part of <a href="https://developers.facebook.com/blog/post/417/">Operation Developer Love</a>, we are are continuing to update our documentation.  Recently, I was talking with some developers in New York, and they were surprised to learn that they could publish updates to people who have liked their <a href="http://developers.facebook.com/docs/opengraph/">Open Graph Pages</a>. 
</p>

<p>
You can publish stream updates to people who like your page just like you can with Facebook Pages. There are two ways to get to the publishing interface:
</p>

<p>
<ul>
<li>From your Web page, click Admin Page next to the Like button.</li>
<p>
<img src="http://a3.sphotos.ak.fbcdn.net/hphotos-ak-snc6/183786_10150105866433553_19292868552_6359560_5484694_n.jpg" align="left" /></p><br /><br /><br /><br />
<li>From Facebook, click "Use Facebook as a Page" under the Account tab or click <a href="http://www.facebook.com/pages/manage/">here.</a></li>
</ul>
</p>

<p>
You can publish stories to people who like your Open Graph Page the same way you write a Facebook post from your own wall. The stories appear in the News Feeds of people who have clicked the Like button on the Open Graph Page.
</p>

<p>
You can also publish using our API. If you associate your Open Graph Page with a Facebook app using the <code>fb:app_id</code> meta tag, you can publish updates to the users who have liked your pages via the Graph API. 
</p>

<p>
First you need to get an access token for your app. This can be obtained with:
</p>

<p>
<pre>
curl -F type=client_credentials \
 -F client_id=your_app_id \
 -F client_secret=your_app_secret \
 https://graph.facebook.com/oauth/access_token
</pre>
</p>

<p>
Using this access token and the URL of your page, you can publish to users via the API with:
</p>

<p>
<pre>
curl -F 'access_token=...' \
 -F 'message=Hello World!' \
 -F 'id=http://www.example.com' \
 https://graph.facebook.com/feed
</pre>
</p>

<p>
Here is some sample PHP code to help you get started:
</p>

<p>
<pre>
&lt;?php

  $feedurl = "YOUR_FEED_URL";
  $ogurl = "YOUR_OPEN_GRAPH_URL"; 
  $app_id = “YOUR_APP_ID”; 
  $app_secret = "YOUR_APP_SECRET";

  $mymessage = urlencode("Hello World!");

  $access_token_url = "https://graph.facebook.com/oauth/access_token"; 
  $parameters = "type=client_credentials&client_id=" .  
  $app_id . "&client_secret=" . $app_secret;
  $access_token = file_get_contents($access_token_url . 
    "?" . $parameters);

  $apprequest_url = "https://graph.facebook.com/feed";
  $parameters = "?" . $access_token . "&message=" . 
    $mymessage . "&id=" . $ogurl . "&method=post";
  $myurl = $apprequest_url . $parameters;

  $result = file_get_contents($myurl);
  echo "post_id" . $result;

?>
</pre>
</p>

<p>
<img src="http://a5.sphotos.ak.fbcdn.net/hphotos-ak-snc6/182850_10150105869533553_19292868552_6359604_57847_n.jpg" /><br />
The story will be published with the attribution of your app name (e.g., “GetConnected”). 
</p>

<p>
See our <a href="https://developers.facebook.com/docs/opengraph#publishing">documentation</a> for more info. Post below with any feedback or questions on how we can better help you.
</p></div>";s:7:"attribs";a:2:{s:0:"";a:1:{s:4:"type";s:9:"text/html";}s:36:"http://www.w3.org/XML/1998/namespace";a:1:{s:4:"lang";s:2:"en";}}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:2:"en";}}}}}i:2;a:6:{s:4:"data";s:6:"





";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:1:{s:27:"http://www.w3.org/2005/Atom";a:5:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:23:"Upgrade to Requests 2.0";s:7:"attribs";a:1:{s:0:"";a:1:{s:4:"type";s:4:"text";}}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"updated";a:1:{i:0;a:5:{s:4:"data";s:20:"2011-02-16T14:05:00Z";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:2:"id";a:1:{i:0;a:5:{s:4:"data";s:45:"urn:uuid:dac028c0-4719-4572-b31b-8d7fa67d670c";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:0:"";s:7:"attribs";a:1:{s:0:"";a:3:{s:4:"href";s:44:"http://developers.facebook.com/blog/post/464";s:3:"rel";s:9:"alternate";s:4:"type";s:9:"text/html";}}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"content";a:1:{i:0;a:5:{s:4:"data";s:7103:"<div><p>
<a href="http://developers.facebook.com/docs/channels#requests">Requests</a> and <a href="http://developers.facebook.com/docs/channels#bookmarks">Bookmarks</a> help users more easily reengage with apps they use. Whenever a user has an action to take within an app, a counter appears next to the bookmark.
</p>

<p><img src="http://developers.facebook.com/attachment/Screen%20shot%202011-02-16%20at%202.03.49%20PM.png" style="margin-left:25px;margin-top:10px;border:1px solid #CCCCCC" align="right" />
Instead of manually managing the bookmark count using the <a href="http://developers.facebook.com/docs/reference/rest/dashboard.incrementcount/">incrementCount</a> and <a href="http://developers.facebook.com/docs/reference/rest/dashboard.decrementcount/">decrementCount</a> APIs, we’re unifying our APIs so the count represents the number of all outstanding requests. This means that as a developer, you only need to worry about one way of updating users about outstanding items in your app - send requests.
</p>

<p>
<b>Sending Requests</b>
</p>

<p>
<a href="http://developers.facebook.com/docs/channels#requests">Requests</a> are a great way to enable users to invite their friends, accept a gift or help them complete a mission in your app. There are now two types of requests that can be sent from an app:
</p>

<p>
<ul>
<li><b>User-generated requests:</b> These requests are confirmed by a user’s explicit action on a request dialog. These requests update the bookmark count for the recipient. You send requests by using the recently launched <a href="http://developers.facebook.com/blog/post/453">Request Dialog</a>.</li>
<li><b>App-generated requests:</b> These requests can be initiated and sent only to users who have authorized your app. Developers can send these requests using the Graph API. Use these requests to update the bookmark count to encourage a user to re-engage in the app (e.g., your friend finished her move in a game and it’s now your turn).</li>

</ul>
</p>
<p>
To use both request types and automatically sync the bookmark count to them, enable “Upgrade to Requests 2.0” in your <a href="http://www.facebook.com/developers/apps.php">Developer App settings</a> on the “Advanced” tab. This switch controls the bookmark counts seen by your users and synchronizes the count with sent requests.
<img src="http://developers.facebook.com/attachment/Screen%20shot%202011-02-16%20at%201.55.11%20PM.png" width="100%" style="margin-top:10px;margin-bottom:10px;border:1px solid #CCCCCC;" align="left" />
</p> 

<p>
<b>HTML/JavaScript example of a user-generated request:</b>
</p>
<p>
<pre>
&lt;html>
  &lt;head>
  &lt;title>My Great Website&lt;/title>
  &lt;/head>
  &lt;body>
  &lt;div id="fb-root">&lt;/div>
  &lt;script src="http://connect.facebook.net/en_US/all.js">
  &lt;/script>
  &lt;script>
    FB.init({ 
      appId:'YOUR_APP_ID', cookie:true, 
      status:true, xfbml:true 
    });

    FB.ui({ method: 'apprequests', 
      message: 'Here is a new Requests dialog...'});
  &lt;/script>
  &lt;/body>
&lt;/html>
</pre>
</p>

<p>
Which will display the following to the user: <br />
<img src="http://developers.facebook.com/attachment/new-requests.jpg" />
</p>

<p>
<b>PHP example of an app-generated request:</b>
</p>

<p>
<pre>
&lt;?php 

  $app_id = YOUR_APP_ID;
  $app_secret = YOUR_APP_SECRET;

  $token_url = "https://graph.facebook.com/oauth/access_token?" .
    "client_id=" . $app_id .
    "&client_secret=" . $app_secret .
    "&grant_type=client_credentials";

  $app_access_token = file_get_contents($token_url);

  $user_id = THE_CURRENT_USER_ID;

  $apprequest_url ="https://graph.facebook.com/" .
    $user_id .
    "/apprequests?message=’INSERT_UT8_STRING_MSG’" . 
    "&data=’INSERT_STRING_DATA’&"  .   
    $app_access_token . “&method=post”;

  $result = file_get_contents($apprequest_url);
  echo(“Request id number: ”, $result);
?>
</pre>
</p>

<p>
The <code>message</code> parameter is a UTF-8 string which describes the request. The <code>data</code> parameter is a string which the app can use to store any relevant data in order to process the request. 
</p>

<p>
<b>Processing requests</b>
</p>

<p>
When a user arrives within your app (via bookmark, notification, etc.), you should first read the outstanding app requests for that user. Then, potentially highlight the request the user wants to act upon and delete requests when the user acts upon them (either ignores or handles them). 
</p>

<p>
<b>PHP example for reading, printing, and deleting requests:</b></p>

<pre>
&lt;?php 

  $app_id = 'YOUR_APP_ID';
  $app_secret = 'YOUR_APP_SECRET';

  $token_url = "https://graph.facebook.com/oauth/access_token?" .
    "client_id=" . $app_id .
    "&client_secret=" . $app_secret .
    "&grant_type=client_credentials";

  $access_token = file_get_contents($token_url);

  $signed_request = $_REQUEST["signed_request"]; 
  list($encoded_sig, $payload) = explode('.', $signed_request, 2);
  $data = json_decode(base64_decode(strtr($payload, '-_', '+/')), true);
  $user_id = $data["user_id"];

  //Get all app requests for user
  $request_url ="https://graph.facebook.com/" .
    $user_id . "/apprequests?" .
    $access_token;
  $requests = file_get_contents($request_url);

  //Print all outstanding app requests
  echo '&lt;pre>';
  print_r($requests);
  echo '&lt;/pre>';

  //Process and delete app requests
  $data = json_decode($requests);
  foreach($data->data as $item) {
    $id = $item->id;
    $delete_url = "https://graph.facebook.com/" .
      $id . "?" . $access_token . "&method=delete";

    $result = file_get_contents($delete_url);
    echo("Requests deleted? " . $result);
  }
?>
</pre>

<p>
The JSON requests data is printed below (note that presence of the <code>from</code> field in the request that is a <b>user-generated</b> request):
</p>

<p>
<pre>
{
   "data":[
      {
         "id":"167548189960088",
         "application":{
            "name":"Cat's Test Site",
            "id":"314268391344"
         },
         "to":{
            "name":"Cissy Lim",
            "id":"100001147247007"
         },
         "data":"'INSERT_STRING_DATA'",
         "message":"'INSERT_UT8_STRING_MSG'",
         "created_time":"2011-02-16T08:37:02+0000"
      },
      {
         "id":"167546793293561",
         "application":{
            "name":"Cat's Test Site",
            "id":"314268391344"
         },
         "to":{
            "name":"Cissy Lim",
            "id":"100001147247007"
         },
         "from":{
            "name":"Cat Lee",
            "id":"220400"
         },
         "message":"Here is a new Requests dialog...",
         "created_time":"2011-02-16T08:21:45+0000"
      }
   ]
}
</pre>
</p>

<p>
These requests will auto-expire after fourteen days to ensure a simple, clean user experience. 
</p>

<p>We believe these improvements will help apps drive more user engagement and encourage all apps to migrate to the new requests model as soon as possible. New apps will automatically use Requests 2.0. Let us know what you think in the comments below.
</p></div>";s:7:"attribs";a:2:{s:0:"";a:1:{s:4:"type";s:9:"text/html";}s:36:"http://www.w3.org/XML/1998/namespace";a:1:{s:4:"lang";s:2:"en";}}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:2:"en";}}}}}i:3;a:6:{s:4:"data";s:6:"





";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:1:{s:27:"http://www.w3.org/2005/Atom";a:5:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:42:"Platform Updates: Operation Developer Love";s:7:"attribs";a:1:{s:0:"";a:1:{s:4:"type";s:4:"text";}}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"updated";a:1:{i:0;a:5:{s:4:"data";s:20:"2011-02-11T15:20:00Z";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:2:"id";a:1:{i:0;a:5:{s:4:"data";s:45:"urn:uuid:e30854e3-0587-4777-a24c-212ea57b3867";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:0:"";s:7:"attribs";a:1:{s:0:"";a:3:{s:4:"href";s:44:"http://developers.facebook.com/blog/post/463";s:3:"rel";s:9:"alternate";s:4:"type";s:9:"text/html";}}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"content";a:1:{i:0;a:5:{s:4:"data";s:4721:"<div><img src="http://developers.facebook.com/attachment/odl_tall.png" style="float:right;margin-left:17px;margin-bottom:5px;" height="213" />

<p><b>Operation Developer Love</b></p>

<p>
This week, we introduced <a href="http://developers.facebook.com/blog/post/462">iframe Tabs for Pages</a>, made progress improving browser performance for HTML5 Games by releasing <a href="http://developers.facebook.com/blog/post/460">JSGameBench version 0.2</a>, and updated our <a href="http://developers.facebook.com/blog/post/461">Platform policies</a>. 
</p>

<p><b>Custom date format in Graph API</b></p>

<p>
To simplify and make things more convenient for developers, applications can now specify a custom date format in the Graph API, using <code>&date_format=[format]</code>, where format is a string, similar to the <a href="http://php.net/manual/en/function.date.php">PHP date function</a>.
</p>

<p>
The example below modifies the date format of a <a href="http://developers.facebook.com/docs/reference/api/event/">specific Event</a>:
</p>

<p>
<pre>
&lt;?php 
   
  $date_format = "F%20j%20Y,%20g:i%20a";
  $graph_url = "http://graph.facebook.com/331218348435&date_format=" 
    . $date_format;

  $event = json_decode(file_get_contents($graph_url));

  echo '&lt;pre>';
  print_r($event);
  echo '&lt;/pre>';

?>
</pre>
</p>

<p>
The example prints <code>start_time</code> and <code>end_time</code> in the specified string format  instead of ISO-8601 formatted date/time or a UNIX timestamp:
<pre>
 [start_time] => March 14 2010, 9:00 pm
 [end_time] => March 15 2010, 12:30 am
</pre>
</p>

<p><b>Age range support for iframe applications</b></p>

<p>
As <a href="http://developers.facebook.com/blog/post/402">previously announced</a>, we’re in the process of deprecating FBML based applications.  As part of that effort, we are adding support to the signed_request passed to iframe applications to replace what is provided via the FBML tags <a href="http://developers.facebook.com/docs/reference/fbml/18-plus/">fb:18-plus</a>, <a href="http://developers.facebook.com/docs/reference/fbml/21-plus/">fb:21-plus</a>, and <a href="http://developers.facebook.com/docs/reference/fbml/restricted-to/">fb:restricted-to</a> so that apps can continue to do appropriate age gating of content.  We have updated the <a href="http://developers.facebook.com/docs/authentication/signed_request">signed_request</a>
 to include an <code>age</code> range object (containing min and max number of the age) in the user field. You can use this feature to customize your app to the user’s age demographic (e.g., allowing U.S. users over 18 to register to vote).  Please note that this <b>does not</b> provide access to specific age of the user.
</p>

<p>
<b>Give users choice and control (re: photo tagging)</b></p>
<p>
Across <a href="http://www.facebook.com/blog.php?post=462201327130">Facebook profiles</a> and now <a href="http://www.facebook.com/notes/facebook-pages/an-upgrade-for-pages/10150090729064822">Pages</a>, a collection of recently tagged photos appears at the top. This feature is intended for users and Page admins to display recently tagged photos of themselves or of their brand to indicate recent activity. Since launch we have received numerous questions about apps letting users change the row of recently tagged photos. 
</p>

<p>
A few apps are enabling a user to manipulate friends' photo strips into a banner by tagging those friends in a set of images.  Tagging multiple people in photos that do not depict them is often seen as spam by users. Spamming users is prohibited by our <a href="http://developers.facebook.com/policy/">Facebook Platform Principles</a> and subject to enforcement. For more information, please see our <a href="http://developers.facebook.com/docs/guides/policy/photos">Examples and Explanations</a>. 
</p>

<p>
<b>Fixing Bugs</b><br />
<a href="http://bugs.developers.facebook.net/">Bugzilla</a> activity for the past 7 days:
<ul>
<li>122 new bugs were reported</li>
<li>48 bugs were reproducible and accepted (after duplicates removed)</li>
<li>6 bugs were fixed (4 previously reported bugs and 2 new bugs)</li>
<li>As of today, there are 4,290 open bugs in Bugzilla</li>
</ul>
</p>

<p>
<b>Forum Activity</b><br />
<a href="http://forum.developers.facebook.net/">Developer Forum</a> activity for the past 7 days:
<ul>
<li>537 New Topics Created</li>
<li>274 New Topics received a reply</li>
<li>Of those 274, 112 were replied to by a Facebook employee</li>
<li>Of those 274, 74 were replied to by a community moderator</li>
</ul>
</p>

<p>
<i>Arjun, an engineer on Platform, is thinking about creating Arjun-time, a time format that counts the seconds since his birth.</i>
</p></div>";s:7:"attribs";a:2:{s:0:"";a:1:{s:4:"type";s:9:"text/html";}s:36:"http://www.w3.org/XML/1998/namespace";a:1:{s:4:"lang";s:2:"en";}}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:2:"en";}}}}}i:4;a:6:{s:4:"data";s:6:"





";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:1:{s:27:"http://www.w3.org/2005/Atom";a:5:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:33:"Introducing iframe Tabs for Pages";s:7:"attribs";a:1:{s:0:"";a:1:{s:4:"type";s:4:"text";}}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"updated";a:1:{i:0;a:5:{s:4:"data";s:20:"2011-02-10T12:00:00Z";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:2:"id";a:1:{i:0;a:5:{s:4:"data";s:45:"urn:uuid:3e84c4ab-a7cd-4eac-b6df-599c62e5c499";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:0:"";s:7:"attribs";a:1:{s:0:"";a:3:{s:4:"href";s:44:"http://developers.facebook.com/blog/post/462";s:3:"rel";s:9:"alternate";s:4:"type";s:9:"text/html";}}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"content";a:1:{i:0;a:5:{s:4:"data";s:5071:"<div><p>
Today <a href="http://www.facebook.com/notes/facebook-pages/an-upgrade-for-pages/10150090729064822">we announced</a> major updates to Facebook Pages to help Page admins manage communications, express their brands, and increase engagement. As part of these changes, we are also updating the model for building apps on Pages.
</p>

<p>
<b>Using iframes in Page Tabs</b></p>
<p>
Many useful applications have been built for Facebook Pages like <a href="http://www.facebook.com/oonamusic?v=app_178091127385">BandPage</a> for artists to share their music with fans  and <a href="http://www.facebook.com/MollySimsOfficial?v=app_135607783795">Shop Now</a> to help Pages sell merchandise on Facebook.  As of today, you can build your Page Tab apps using iframes rather than FBML.  This means you can now build apps that run across Facebook (including Pages and Canvas applications) using the same simple, standards-based web programming model (HTML, JavaScript, and CSS). In addition, you can easily integrate <a href="http://developers.facebook.com/plugins">social plugins</a> and the <a href="http://graph.facebook.com/">Graph API</a> within your tab.
</p>

<p>
<b>How to Add an iframe Page Tab</b></p>
<p>
Enable iframes by editing the Facebook Integration settings on the <a href="http://www.facebook.com/developers">Developer App</a>:
<img src="http://developers.facebook.com/attachment/Screen%20shot%202011-02-10%20at%209.56.12%20AM.png" style="margin:10px;width:600px" />
</p>

<p>
Specify a <b>Tab Name</b> and a <b>Tab URL</b> that is loaded when the user selects your Tab on a given Facebook Page. Finally, to add the app to a Page, an admin of the Facebook Page must navigate to your app's Profile Page and select "Add to my Page.” You can see step by step instructions in <a href="http://developers.facebook.com/docs/guides/canvas#tabs">our guide</a>.
</p>

<p>
<b>Updated <a href="http://developers.facebook.com/docs/authentication/signed_request">signed_request</a></b>
</p>
<p>
When a user lands on the Facebook Page, she will see your Page Tab added in the left-hand menu. When a user selects your app in the left-hand menu, the app will receive the <a href="http://developers.facebook.com/docs/authentication/signed_request">signed_request</a> parameter with one additional parameter, page, a JSON array which contains the ‘id’ of the Facebook Page your Tab is hosted within, a boolean (‘liked’) indicating whether or not a user has liked the Page, and a boolean (‘admin’) indicating whether or not the user is an ‘admin’ of the Page along with the user info array.  If a user has authorized your application, the signed request will also contain an access token and the user id for the current viewing user so you can personalize your application for them.
</p>
<p>
In addition, your application will also receive a string parameter called app_data as part of signed_request if an app_data parameter was set in the original query string in the URL your tab is loaded on. For the Shop Now link above, that could look like this: "http://www.facebook.com/MollySimsOfficial?v=app_135607783795&app_data=any_string_here". You can use that to customize the content you render if you control the generation of the link.
</p>
<p>
<pre>
{
   "algorithm":"HMAC-SHA256",
   "expires":1297328400,
   "issued_at":1297322606,
   "oauth_token":"OAUTH_TOKEN",
   "app_data":"any_string_here",
   "page":{
      "id":119132324783475,
      "liked":true,
      "admin":true
   },
   "user":{
      "country":"us",
      "locale":"en_US"
   },
   "user_id":"USER_ID"
}
</pre>
</p>

<p>
<b>Policy Revisions</b></p>
<p>
We’ve also revised our <a href="http://developers.facebook.com/policy/">Platform and Page policies</a> to ensure that apps on Page Tabs maintain a high quality user experience and do not share information between Pages. 
</p>

<a name="fbml_roadmap"></a><p>
<b>FBML Roadmap</b></p>
<p>
With our recent launch of <a href="http://developers.facebook.com/blog/post/453">Requests</a> and the support for iframe on Pages Tabs, we are now ready to move forward with our previously <a href="http://developers.facebook.com/blog/post/402">announced plans</a> to deprecate FBML and FBJS as a primary technology for building apps on Facebook.  On March 11, 2011, you will no longer be able to create new FBML apps and Pages will no longer be able to add the <a href="http://www.facebook.com/apps/application.php?id=4949752878&b">Static FBML app</a>.  While all existing apps on Pages using <a href="http://developers.facebook.com/docs/reference/fbml/"> FBML</a> or the <a href="http://www.facebook.com/apps/application.php?id=4949752878&b">Static FBML app</a> will continue to work, we strongly recommend that these apps transition to iframes as soon as possible. Lastly, we want to be clear that our deprecation of FBML does not impact <b>XFBML</b>, such as the tags that support social plugins.
</p>

<p>
We are excited to see the new types of apps you build using iframes in Page Tabs. Please leave any comments or questions below.
</p></div>";s:7:"attribs";a:2:{s:0:"";a:1:{s:4:"type";s:9:"text/html";}s:36:"http://www.w3.org/XML/1998/namespace";a:1:{s:4:"lang";s:2:"en";}}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:2:"en";}}}}}i:5;a:6:{s:4:"data";s:6:"





";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:1:{s:27:"http://www.w3.org/2005/Atom";a:5:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:42:"HTML5 Games 0.2: Integers are Your Friends";s:7:"attribs";a:1:{s:0:"";a:1:{s:4:"type";s:4:"text";}}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"updated";a:1:{i:0;a:5:{s:4:"data";s:20:"2011-02-09T14:00:00Z";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:2:"id";a:1:{i:0;a:5:{s:4:"data";s:45:"urn:uuid:b1f45607-ce8e-4a4b-a323-2f9ce9ba03e2";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:0:"";s:7:"attribs";a:1:{s:0:"";a:3:{s:4:"href";s:44:"http://developers.facebook.com/blog/post/460";s:3:"rel";s:9:"alternate";s:4:"type";s:9:"text/html";}}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"content";a:1:{i:0;a:5:{s:4:"data";s:12084:"<div><img src="http://developers.facebook.com/attachment/jsgamesbench_v1.png" style="margin-left: 10px; margin-bottom: 10px; float:right" width="300"/>
<p>
Two weeks ago <a href="http://www.facebook.com/brucero">Bruce</a> and I <a href="http://www.facebook.com/notes/facebook-engineering/html5-games-01-speedy-sprites/491691753919">released JSGameBench version 0.1</a>. Today marks the release of <a href="https://github.com/facebook/jsgamebench">version 0.2</a>, a much faster and cleaner version. We continue to learn both from tightening the code and from the strong HTML5 community. Version 0.2 reinforces our belief in HTML5 as a strong, horizontal platform for games and highly interactive applications across the web.
</p>

<p><b>Benchmarking</b></p>
<p>
In order to talk about browser performance, we needed to standardize. We now have two machines that will be our testing machines:
</p>

<p>
<ul>
<li><b>For OS X:</b> a MacBook Pro laptop, currently OS X 10.6.6, 4GB of RAM, 2.66 GHz Intel Core i7, and NVIDIA GT 330M with 512MB of RAM.</li>
<li><b>For Windows:</b> a Lenovo T410s laptop, currently Windows 7 Enterprise, 4GB of RAM, 2.53 GHz Intel Core i5, and NVIDIA NVS 3100M with 512MB of RAM.</li>
</p>
</ul>
</p>

<p>
Both of these laptops are significantly less powerful than the Mac Pro the original tests were run on. In addition, the 3100M offers approximately half the performance of the 330M.
</p>

<p><b>More is Better</b></p>
<p>
Thanks to help from the HTML5 community, JSGameBench has roughly doubled performance in the most widely used browsers in only two weeks. This a very promising development for the future of HTML5 games and interactive apps. The two most significant changes are clamping positions to integer values and using the <code>transform/transform3d</code> style property.
<img src="http://developers.facebook.com/attachment/scores.png" style="margin-bottom:10px; margin-top:10px; margin-right:10px; float:left" width="95%">
</p>

<p>
Also, despite the far less powerful graphics cards and slower CPU  in the Lenovo 410s, Win 7’s hardware accelerated browsers -- Firefox 4, Internet Explorer 9, and Chrome 11 -- continue to dominate, achieving scores above 1,000. Our new leader, Firefox 4, is well ahead of the pack.
</p>

<p><b>Some Thank Yous</b></p>
<p>
First, thanks to Bruno Garcia, a developer at <a href="http://www.threerings.net/about/crew.html">Three Rings</a>, who submitted a pull request clamping position values to integers. An obvious improvement for software render pipelines, but one we hadn’t thought to try. For axis-aligned sprites, clamping to integer values was faster in every browser except for Chrome 11 on Windows. A huge win and the majority of the performance gains. Thanks, Bruno!
</p>

<p>
Second, thanks to <a href="http://www.zynga.com/">Zynga</a>’s Laurent Desegur, Paul Bakaus and Rocco Di Leo. At the <a href="http://www.facebook.com/video/video.php?v=696729990595&oid=9445547199&comments">HTML5 tech talk</a>, we had a chance to talk about HTML5 performance and some of their ideas. Paul also <a href="http://paulbakaus.com/">blogs</a> extensively about HTML5 tricks. 
</p>

<p><b>Desktop Recommendations</b></p>
<p>
For the desktop browsers, the following techniques generated the highest frame rates:
<ul>
<li>Snapping positions to integer values rather than using floating point values. JavaScript supports several different ways to snap, such as <code>“parseInt”</code> and  <code>“| 0”</code>. We would expect using the or operator to be faster than a function call, but have not yet tested this. Note that snapping could generate visible artifacts, particularly at very low resolutions.</li>
<li>Using the <code>DIV</code> tag with background image instead of <code>IMG</code> tag. The difference is particularly noticeable when using individual sprites instead of sprite sheets, as changing the <code>IMG</code>’s src property is very slow.</li>
<li>Many individual sprites are faster than sprite sheets in nearly every case. The exceptions were the fully hardware accelerated browsers on Windows, where sprite sheets offer a 5-10% advantage. Unless you are only targeting those browsers, we recommend staying with individual sprites. For browsers with the <code>CANVAS</code> tag, we expect an optimum balance of download and draw performance is to download sprite sheets but then use <code>CANVAS</code> to cut them up.</li>
<li>Update DOM elements rather than using innerHTML to load the parent. For several browsers, Firefox 4, Chrome 10 and 11, and IE9, innerHTML was faster, particularly for rotated sprites. However, for those browsers <code>CANVAS</code> tag performance was far superior to DOM manipulation, so update and switch to <code>CANVAS</code> when possible.</li>
<li>For axis-aligned images with integer position values, the <code>CANVAS</code> tag was superior across all desktop browsers. This had not been the case with floating point values -- and indicates software blitting in their render pipelines -- but if you are snapping and drawing axis aligned images, use <code>CANVAS</code> when you are able to.</li>
<li>For browsers that support 3D transforms -- we are currently testing on Chrome and Safari -- using <code>translate3d(x,y,z)</code> is equal to or faster than <code>translate(x,y)</code>.</li>
<li>On desktops, using CSS transitions for motion or CSS keyframes for animations were slower than simply using JavaScript for these tasks. Worse, they often generated noisy framerates, so they are not a good solution for games in desktop browsers.</li>
</ul>
</p>

<p>
In order to reduce JSGameBench’s testing time, we have chosen to use these recommendations -- positions snapped to integer values, DIV tags with background images, updating DOM elements, 3D transforms when possible, no CSS transitions or keyframes -- as our default test. One further tweak was to settling on the transform property “rotate” since  “rotate“ versus “matrix“ generated no difference. We believe that HTML5 game developers and browser developers will gain the most if we optimize the smallest number of render paths, rather than constantly testing every possibility.
</p>

<p><b>Mobile Differences</b></p>
<p>
We thought the most interesting part of the HTML5 tech talk was how different our performance test results were. Much of this week was spent exploring where those differences might have come from, beyond normal testing variance. We believe the single largest reason for differences in our results comes from the iPhone -- or more specifically, Mobile Safari running on the  iOS ecosystem. While many HTML5 techniques work well on Mobile Safari, truly wringing maximum performance will require more special case code than any other browser.
</p>

<p>We have primarily been testing desktop browsers so far, but what follows are our preliminary points of data about iOS.</p>

<p><b>CSS</b></p>
<p>
For Safari, both desktop and mobile, CSS transitions and animations are hardware accelerated. As we previously discussed, this acceleration is not a win on desktop, but on iOS, it generates intriguing results.
</p>

<p>
CSS transitions are pretty simple. For a given CSS property, such as position, CSS transitions provide a method to interpolate between the current value and the new value. For example, on a Webkit browser the following CSS:
</p>

<p>
<code>
	#Foo {<br />
	&nbsp;&nbsp;-webkit-transition: left 0.1s linear;<br />
	&nbsp;&nbsp;left: 45px;<br />
	}<br />
</code>
</p>

<p>
This will interpolate between Foo’s current left value and “45px” in 0.1 seconds using linear interpolation. (<a href="http://www.the-art-of-web.com/css/timing-function/">The Art of the Web</a> has a nice discussion and demos of transition timing.) Generally, CSS transitions work for smoothly varying a CSS property.
</p>

<p>
CSS keyframe also provide a different approach, allowing you to set keyframes for a given property. Normally, those properties would still be smoothly interpolated, but as Paul Baukus <a href="http://paulbakaus.com/2010/12/07/finally-sprite-animations-implemented-via-css3-animations/">discovered</a> (and <a href="http://paulbakaus.com/2010/12/15/sprite-animations-on-css-transitions-revisited/">refined</a>), by exploiting numerical precision limits in the browser, it is possible to snap between values. 
</p>

<p>
For example, to use keyframes to run a 2 frame animation of the flickering drive flame on our spaceship, you would use a CSS keyframe like this:
</p>

<p>
<code>
	@-webkit-keyframes 'ship' {<br />
	&nbsp;&nbsp;from { background-position: 0px 0px; }<br />
	&nbsp;&nbsp;49.99% { background-position: 0px 0px; }<br />
	&nbsp;&nbsp;50% { background-position: -128px 0px; }<br />
	&nbsp;&nbsp;to { background-position: -128px 0px; }<br />
	}<br />
</code>
</p>

<p>
This example animates the background image position. To accomplish the same effect using a DIV element masking an IMG element, you would instead use:
</p>

<p>
<code>
	@-webkit-keyframes 'ship' {<br />
	&nbsp;&nbsp;from { -webkit-transform: translate(0px,0px,0); }<br />
	&nbsp;&nbsp;49.99% { -webkit-transform: translate(0px,0px,0); }<br />
	&nbsp;&nbsp;50% { -webkit-transform: translate(-128px,0px,0); }<br />
	&nbsp;&nbsp;to { -webkit-transform: translate(-128px,0px,0); }<br />
	}<br />
</code>
</p>

<p>
In both cases, you would associate the animation with the DIV via:
</p>

<p>
<code>
	img.ship_animating {<br />
	&nbsp;&nbsp;-webkit-animation-name: 'ship';<br />
	&nbsp;&nbsp;-webkit-animation-timing-function: linear;<br />
	&nbsp;&nbsp;-webkit-animation-duration: 0.25s;<br />
	&nbsp;&nbsp;-webkit-animation-iteration-count: infinite;<br />
	}<br />
</code>
</p>

<p>
Using HTML5 techniques form the desktop, both iOS and Android return values in the 20-30 sprites range, using a 20 fps baseline. By using the DIV with background position approach, performance on the iPhone increases by 25% or more, warranting further research.
</p>

<p>
Taking advantage of the second CSS keyframe technique -- using a DIV to mask an IMG tag -- generated similar performance increases, but began severely stuttering JS execution. We found similar results using CSS transitions to move the game objects: the JavaScript thread would execute erratically, likely as a result of the UI and render threads on iOS being higher priority.
</p>

<p><b>CSS Only?</b></p>
<p>
Viewing the thread starvation led us to try a further experiment. Rather than relying on JavaScript to update object positions, what performance levels are achievable if all of the sprite motion is in CSS? The results were impressive, with the iPhone 4 easily pushing over 100 moving, animating, and rotated sprites. Unfortunately, this level of performance is achieved at the expense of JavaScript execution, with the JS thread getting called at an erratic 2-5fps.
</p>

<p>
Is it possible to build a game using this approach? Almost certainly, but it is going to be a very quirky development path and iOS specific. Still intriguing, however.
</p>

<p><b>Browser Improvements</b></p>
<p>
As always, version 0.2 brings a list of requests to browser manufacturers:
<ul>
<li>JavaScript control of screen rotation, including the ability to lock to landscape or portrait. With mobile, auto rotation is incredibly disruptive to interactive apps.</li>
<li>Although the CSS tricks are interesting, the broadest win for HTML5 as an effective interactive platform is for browsers to expose hardware accelerate render pipelines to JavaScript directly rather than forcing developers to attempt to contort their game engines into JS/CSS hybrids.</li>
</ul>
</p>

<p><b>That’s All for Now</b></p>
<p>
We will continue to improve and refine JSGameBench in the coming weeks. We’ve begun to reorganize the code to better serve as a reference design for JS games and have a list of tasks ahead of us. We continue to be sure that we’ve missed good ideas and look forward to continued feedback.  HTML5 continues to impress us and we are excited by what we will bring to JSGameBench next.
</p></div>";s:7:"attribs";a:2:{s:0:"";a:1:{s:4:"type";s:9:"text/html";}s:36:"http://www.w3.org/XML/1998/namespace";a:1:{s:4:"lang";s:2:"en";}}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:2:"en";}}}}}i:6;a:6:{s:4:"data";s:6:"





";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:1:{s:27:"http://www.w3.org/2005/Atom";a:5:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:37:"Update to Platform Developer Policies";s:7:"attribs";a:1:{s:0:"";a:1:{s:4:"type";s:4:"text";}}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"updated";a:1:{i:0;a:5:{s:4:"data";s:20:"2011-02-09T10:00:00Z";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:2:"id";a:1:{i:0;a:5:{s:4:"data";s:45:"urn:uuid:c50bf6bb-d2b2-4764-8bb1-db5bfa404f90";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:0:"";s:7:"attribs";a:1:{s:0:"";a:3:{s:4:"href";s:44:"http://developers.facebook.com/blog/post/461";s:3:"rel";s:9:"alternate";s:4:"type";s:9:"text/html";}}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"content";a:1:{i:0;a:5:{s:4:"data";s:1380:"<div><p>
For the past year, we’ve required ad providers operating on Apps on Facebook.com (i.e., Canvas apps) to <a href="http://developers.facebook.com/blog/post/359">sign terms with us</a>.  These terms ensure that these ad providers are committed to conforming to our user data protection policies and also ensure ad quality for our users. You can see the list of ad providers that have signed these terms <a href="http://developers.facebook.com/adproviders/">here</a>.
</p>
 
<p>
Today, we’ve modified our <a href="http://developers.facebook.com/policy/#policies">Platform policies</a> to require that developers operating on Facebook.com only use these ad providers in their apps. We will begin enforcing this policy on 2/28, which should provide you and other developers the time required to switch ad providers or to help us sign terms with the ad providers you may be using. We will continue to add other ad providers in the coming weeks.  If your ad provider is not on this list, we encourage you to contact them to determine if they are planning on signing our terms.
</p>

<p>
We welcome your questions in the comments below.  If you are an ad or offer network or related service, and wish to contact us directly, please direct inquiries to our <a href="http://www.facebook.com/help/contact.php?show_form=platformadhelp">ad provider application form</a>.
</p></div>";s:7:"attribs";a:2:{s:0:"";a:1:{s:4:"type";s:9:"text/html";}s:36:"http://www.w3.org/XML/1998/namespace";a:1:{s:4:"lang";s:2:"en";}}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:2:"en";}}}}}i:7;a:6:{s:4:"data";s:6:"





";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:1:{s:27:"http://www.w3.org/2005/Atom";a:5:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:42:"Platform Updates: Operation Developer Love";s:7:"attribs";a:1:{s:0:"";a:1:{s:4:"type";s:4:"text";}}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"updated";a:1:{i:0;a:5:{s:4:"data";s:20:"2011-02-04T18:00:00Z";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:2:"id";a:1:{i:0;a:5:{s:4:"data";s:45:"urn:uuid:cd54e0b5-631c-4335-83b9-e9fc2d406b43";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:0:"";s:7:"attribs";a:1:{s:0:"";a:3:{s:4:"href";s:44:"http://developers.facebook.com/blog/post/459";s:3:"rel";s:9:"alternate";s:4:"type";s:9:"text/html";}}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"content";a:1:{i:0;a:5:{s:4:"data";s:3451:"<div><img src="http://developers.facebook.com/attachment/devlove_blue.png" style="float:right;margin-left:12px;margin-bottom:5px" height="100" width="100" />
<p>
<b>Operation Developer Love</b><br />
This week, we launched two new features for apps that use Facebook Credits within their games: <a href="http://developers.facebook.com/blog/post/458">buy with friends and frictionless payments</a>. 
</p>

<p>
<b>Sharing test accounts between apps</b><br />
Since we launched the ability to <a href="http://developers.facebook.com/blog/post/429">create and manage test accounts</a> via the Graph API, many of you have requested the ability to share test accounts across applications. As a result, we recently implemented additional parameters that let you do this.
</p>

<p>
Use the Graph API with the application access token to add an existing test account to it. The following PHP example shows how to add an existing test user to another application.
<p>

<pre>
&lt;?php

  //owner_app_id will create the test user
  $owner_app_id = 'OWNER_APP_ID';
  $owner_app_secret = 'OWNER_APP_SECRET';

  //app_id will share the test user with owner_app_id
  $app_id = 'YOUR_APP_ID';
  $app_secret = 'YOUR_APP_SECRET';

  $owner_token_url = "https://graph.facebook.com/oauth/access_token?" .
    "client_id=" . $owner_app_id .
    "&client_secret=" . $owner_app_secret .
    "&grant_type=client_credentials";

  $owner_access_token = file_get_contents($owner_token_url);
 
  $token_url = "https://graph.facebook.com/oauth/access_token?" .
     "client_id=" . $app_id .
     "&client_secret=" . $app_secret .
     "&grant_type=client_credentials";
   
  $access_token = file_get_contents($token_url);

  //create test user
  $request_url ="https://graph.facebook.com/" .
    $owner_app_id .
    "/accounts/test-users?installed=true&permissions=read_stream&" .
    $owner_access_token;

  $requests = file_get_contents($request_url);
  $post_url = $request_url . "&method=post";

  $result = file_get_contents($post_url);
  
  $obj = json_decode($result);
  $test_user_id = $obj->{'id'};

  //remove "access_token="
  $owner_access_token_short = substr($owner_access_token, 13);

  //add test user to app_id
  $request_url_test ="https://graph.facebook.com/" .
    $app_id .
    "/accounts/test-users?installed=true&permissions=read_stream&uid=" .
    $test_user_id . "&owner_access_token=" .
    $owner_access_token_short . "&" . $access_token;

  $result = file_get_contents($request_url_test);
  $post_url = $request_url_test . "&method=post";

  $result = file_get_contents($post_url);
?>
</pre>

<p>
More information can be found in <a href="http://developers.facebook.com/docs/test_users">our documentation</a>.
</p>

<p>
<b>Fixing Bugs</b><br />
<a href="http://bugs.developers.facebook.net/">Bugzilla</a> activity for the past 7 days:<br />
<ul>
<li>126 new bugs were reported</li>
<li>71 bugs were reproducible and accepted (after duplicates removed)</li>
<li>6 bugs were fixed (5 previously reported bugs and 1 new bugs)</li>
<li>As of today, there are 4,452 open bugs in Bugzilla</li>
</ul>
</p>

<p>
<b>Forum Activity</b><br />
<a href="http://forum.developers.facebook.net/">Developer Forum</a> activity for the past 7 days: <br />
<ul>
<li>421 New Topics Created</li>
<li>301 New Topics Received at least 1 reply</li>
<li>Of those 301, 138 were replied to by an Admin</li>
<li>Of those 301, 112 were replied to by a Moderator</li>
</ul>
</p></div>";s:7:"attribs";a:2:{s:0:"";a:1:{s:4:"type";s:9:"text/html";}s:36:"http://www.w3.org/XML/1998/namespace";a:1:{s:4:"lang";s:2:"en";}}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:2:"en";}}}}}i:8;a:6:{s:4:"data";s:6:"





";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:1:{s:27:"http://www.w3.org/2005/Atom";a:5:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:37:"Two New Features for Facebook Credits";s:7:"attribs";a:1:{s:0:"";a:1:{s:4:"type";s:4:"text";}}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"updated";a:1:{i:0;a:5:{s:4:"data";s:20:"2011-02-03T14:30:00Z";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:2:"id";a:1:{i:0;a:5:{s:4:"data";s:45:"urn:uuid:679474fb-6789-4008-8e90-78430519be56";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:0:"";s:7:"attribs";a:1:{s:0:"";a:3:{s:4:"href";s:44:"http://developers.facebook.com/blog/post/458";s:3:"rel";s:9:"alternate";s:4:"type";s:9:"text/html";}}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"content";a:1:{i:0;a:5:{s:4:"data";s:3151:"<div><p>
Today, we’re introducing two features for developers that use Facebook Credits as the primary virtual currency within their games: buy with friends and frictionless payments. These features enhance the user experience when credits are integrated as the in-game currency and premium virtual goods are priced in credits.
</p>

<p>
<b>Buy with friends</b><br />
Buy with friends gives people the option to share a discount with their friends after they make  purchases in games. 
</p>

<p>
After making a purchase, the user has the option to share a discount for the same item with their friends through the news feed. Their friends can respond by either going to the game to buy the item, or simply making a purchase inline without losing the context of what they were doing on Facebook. 
</p>

<p>
Only friends who play the same game see the deal in their news feed. It’s up to the developer to decide which purchases can be shared, what level of discount to offer and how long the deal should run.  Buy with friends has performed well in our tests -- more than half of people who were offered a deal in-game decided to share it with their friends, and the engagement and conversion rates on the resulting posts were also strong. 
</p>

<p>
<img src="/attachment/bwf2.jpg">
<img src="/attachment/bwf.jpg">
</p>

<p>
Simply configure a product and a deal using the Graph API, and then create a pay button:
</p>

<pre>
 var obj = {
   method: "pay",
   dev_purchase_params: {product_id: [product id], deal_id: [deal id]}
 };
 FB.ui(obj, callback);
</pre>

<p>
<b>Frictionless payments</b><br />
Frictionless payments enable people to make small purchases (currently 30 credits or less) with no friction -- and almost instantly. Instead of using the Facebook Credits user interface, these purchases happen directly in the game’s UI, making it easy for people to make purchases without interruption. 
</p>

<p>
The frictionless API is a Graph API call:
<pre>
POST https://graph.facebook.com/[app_id]/payments?access_token=
[access_token]&from=[user_id]&to=[app_id]&order_details=[order_details]
</pre>
</p>

<p>
We’ve tested frictionless payments with a few beta partners and have seen positive results from a purchase experience that combines the look and feel of the game with the virtual currency of Platform. You can see examples of frictionless payments in <a href="http://apps.facebook.com/mahjongg-dimensions">Mahjongg Dimensions</a>, <a href="http://apps.facebook.com/RavenwoodFair/">Ravenwood Fair</a> and <a href="http://apps.facebook.com/drawmything/">Draw My Thing</a>. 
</p>

<p>
One point to note is that these two features are exclusive to Facebook Credits and therefore can only be used with virtual goods. You can apply to enable buy with friends and frictionless payments <a href="http://www.facebook.com/help/contact_us.php?id=157379954315015">here</a>. Developer documentation and sample code also is available <a href="http://developers.facebook.com/docs/creditsapi">here.</a></p>

<p>
<i>Prashant Fuloria, a product management director, is looking out for cool deals he hopes his friends share with him.</i></p></div>";s:7:"attribs";a:2:{s:0:"";a:1:{s:4:"type";s:9:"text/html";}s:36:"http://www.w3.org/XML/1998/namespace";a:1:{s:4:"lang";s:2:"en";}}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:2:"en";}}}}}i:9;a:6:{s:4:"data";s:6:"





";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:1:{s:27:"http://www.w3.org/2005/Atom";a:5:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:47:" Calling All Entrepreneurs - Come Hack with Us!";s:7:"attribs";a:1:{s:0:"";a:1:{s:4:"type";s:4:"text";}}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"updated";a:1:{i:0;a:5:{s:4:"data";s:20:"2011-01-31T03:00:00Z";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:2:"id";a:1:{i:0;a:5:{s:4:"data";s:45:"urn:uuid:98c38ab9-5010-46b4-b238-b86c66a7eae9";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:0:"";s:7:"attribs";a:1:{s:0:"";a:3:{s:4:"href";s:44:"http://developers.facebook.com/blog/post/457";s:3:"rel";s:9:"alternate";s:4:"type";s:9:"text/html";}}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"content";a:1:{i:0;a:5:{s:4:"data";s:3067:"<div><p>
This morning, the White House introduced the <a href="http://www.facebook.com/startupamerica">Startup America Partnership</a> to bring people across public and private industries together to foster entrepreneurship. As a company with strong entrepreneurial roots, we’re pleased to be involved with this project to provide the resources and technologies needed for entrepreneurs to create the next great companies. 
</p>

<p>
As part of our commitment, we plan to host 12 Startup Days in 2011 to provide early-stage companies with engineering and design support on the Facebook Platform. Startup Days are monthly events for entrepreneurs to work and <a href="http://www.facebook.com/video/video.php?v=238358730483">hack with us</a>  to build new apps and websites that incorporate the latest social technologies. 
</p>

<p>
In addition, we plan to stay active within open source communities and are proud of what we've contributed in the past. Open source technologies continue to be important to startups that are scaling and growing quickly. They allow entrepreneurs to spend more time working on their products.
</p>

<p>
Over the past few years we've been contributing to a wide range of existing projects, from PHP to memcached to Varnish and many <a href="http://www.facebook.com/opensource/">others</a>. We also open source our own projects, ranging from major pieces of infrastructure (most recently <a href="https://github.com/facebook/hiphop-php/wiki/">HipHop for PHP</a>) to small tools that make developing all sorts of software faster and easier (such as <a href="http://www.facebook.com/video/video.php?v=691530056305">XHP</a> and <a href="http://three20.info/">Three20</a>). 
</p>

<p>
These initiatives build on past programs such as the 170 <a href="http://developers.facebook.com/devgarage">Developer Garages</a> hosted around the world, fbFund (a $10 million fund created in partnership with Founder’s Fund and Accel Partners to invest in talented entrepreneurs and developers), and recently announced initiatives such as <a href="http://www.kpcb.com/initiatives/sfund/">Kleiner Perkin’s sFund</a> and our <a href="http://developers.facebook.com/blog/post/405">involvement</a> with organizations like Y Combinator.
</p>

<p>
Companies like Zynga, Playfish and Playdom in three years have shown what’s possible in social gaming on Facebook Platform. They’ve created a new industry through developing fun and meaningful experiences for the 200 million people who actively play their games with friends on Facebook. We’re starting to see the same thing happen in areas like commerce, news, music, and entertainment, and encourage startups to pursue building products that give people new ways to connect with their friends in these industries.
</p>

<p>
We’ve bet big on startups, especially those who build social into their products from the ground up. We look forward to seeing many of you join us and the other companies working with the Startup America Partnership. Stay tuned for details on the next Startup Day.
</p></div>";s:7:"attribs";a:2:{s:0:"";a:1:{s:4:"type";s:9:"text/html";}s:36:"http://www.w3.org/XML/1998/namespace";a:1:{s:4:"lang";s:2:"en";}}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:2:"en";}}}}}}}}}}}}s:4:"type";i:512;s:7:"headers";a:7:{s:12:"content-type";s:35:"application/atom+xml; charset=UTF-8";s:3:"p3p";s:72:"CP=Facebook does not have a P3P policy. Learn why here: http://fb.me/p3p";s:10:"set-cookie";s:39:"lsd=2nwoT; path=/; domain=.facebook.com";s:16:"content-encoding";s:4:"gzip";s:10:"connection";s:5:"close";s:17:"transfer-encoding";s:7:"chunked";s:4:"date";s:29:"Tue, 22 Feb 2011 15:31:22 GMT";}s:5:"build";s:14:"20110128231735";}