a:4:{s:5:"child";a:1:{s:0:"";a:1:{s:3:"rss";a:1:{i:0;a:6:{s:4:"data";s:0:"";s:7:"attribs";a:1:{s:0:"";a:1:{s:7:"version";s:3:"2.0";}}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:1:{s:0:"";a:1:{s:7:"channel";a:1:{i:0;a:6:{s:4:"data";s:0:"";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:2:{s:27:"http://www.w3.org/2005/Atom";a:1:{s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:0:"";s:7:"attribs";a:1:{s:0:"";a:2:{s:3:"rel";s:3:"hub";s:4:"href";s:29:"http://tumblr.superfeedr.com/";}}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:0:"";a:5:{s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:0:"";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:31:"The MongoDB NoSQL Database Blog";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:9:"generator";a:1:{i:0;a:5:{s:4:"data";s:22:"Tumblr (3.0; @mongodb)";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:24:"http://blog.mongodb.org/";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"item";a:20:{i:0;a:6:{s:4:"data";s:0:"";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:1:{s:0:"";a:5:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:29:"The State of MongoDB and Ruby";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:8408:"<p>The state of Ruby and MongoDB is strong. In this post, I’d like to describe some of the recent developments in the Ruby driver and provide a few notes on Rails and the object mappers in particular.</p>
<h3>The Ruby Driver</h3>
<p>We just released v1.2 of the MongoDB Ruby driver. This release is stable and supports all the latest features of MongoDB. If you haven’t been paying attention to the driver’s development, the Cliff’s Notes are below. (Note that if you’re an using older version of the driver, you owe it to your app to upgrade).</p>
<p>If you’re totally new to the driver, you may want to read <a title="Being Awesome with the Ruby Driver" href="http://rubylearning.com/blog/2010/12/21/being-awesome-with-the-mongodb-ruby-driver/">Ethan’s Gunderson’s excellent post</a> introducing it before continuing on.</p>
<h3>Connections</h3>
<p>There are now two connection classes: <code><a title="Connection class docs" href="http://api.mongodb.org/ruby/current/Mongo/Connection.html">Connection</a></code> and <code><a title="ReplSetConnection class docs" href="http://api.mongodb.org/ruby/current/Mongo/ReplSetConnection.html">ReplSetConnection</a></code>. The first simply creates a connection to a single node, primary or secondary. But you probably already knew that.</p>
<p>The <code>ReplSetConnection</code> class is brand new.  It has a slightly different API and must be used when connecting to a replica set. To connect, initialize the <code>ReplSetConnection</code> with a set of seed nodes followed by any connection options.</p>
<script src="https://gist.github.com/786661.js?file=repl_set_connection.rb"></script><!--ReplSetConnection.new(['db1.app.com'], ['db2.app.com'],   :rs_name =&gt; &quot;myapp&quot;) &lt;/pre&gt;&lt;/code&gt;--><p>You can pass the replica set’s name as a kind of sanity check, ensuring that each node connected to is part of the same replica set.</p>
<h3>Replica sets</h3>
<p>If you’re running replica sets (and why wouldn’t you be?), then you’ll first want to make sure you connect with the ReplSetConnection class. Why? Because this class facilitates discovery, automatic failover, and read distribution.</p>
<p>Discovery is the process of finding the nodes of a set and determining their roles. When you pass a set of seed nodes to the ReplSetConnection class, you may now know which is the primary node. The driver will find that node and ensure that all writes are sent to it. In addition, the driver will discover any other nodes not specified as seeds and then cache those for failover and, optionally, read distribution.</p>
<p>Failover works like this. Your application is humming along when, for whatever reason, the primary member of the replica set goes down. So subsequent operations will fail, and the driver will raise the Mongo::ConnectionFailure exception until the replica set has successfully elected a new primary.</p>
<p>We’ve decided that connection failures shouldn’t be handled automatically by the driver. However, it’s not hard to achieve the oft-sought seamless failover. You simply need to make sure that 1) all writes use safe mode and 2) that all operations are wrapped in a rescue block. Details on just how to do that can be found in the <a title="Replica Set Docs" href="http://api.mongodb.org/ruby/current/file.REPLICA_SETS.html">replica set docs</a>.</p>
<p>Finally, we should mention read distribution. For certain read-heavy applications, it’s useful to distribute the read load to a number of slave nodes, and the driver now facilitates this. </p>
<script src="https://gist.github.com/786661.js?file=repl_set_read_secondary.rb"></script><!--<code><pre>ReplSetConnection.new(['db1.app.com'], ['db2.app.com'],   :read_secondary => true)</pre></code> --><p>With :read_secondary => true, the connection will send all reads to an arbitrary secondary node. When running Ruby in production, where you’ll have a whole bunch of Thins and Mongrels or forked workers (<span>à</span> la Unicorn and Phusion), you should get a good distribution of reads across secondaries. </p>
<h3>Write concern (i.e., safe mode plus)</h3>
<p><a title="Write concern in Ruby" href="http://api.mongodb.org/ruby/current/file.WRITE_CONCERN.html">Write concern</a> is the term we use to describe safe mode and its options. For instance, you can use safe mode to ensure that a given write blocks until it’s been replicated to three nodes by specifying <code>:safe => {:w => 3}</code>. For example:</p>
<p>That gets verbose after a while, which is why the Ruby driver supports setting a default safe mode on the Connection, DB, and Collection levels as well. For instance:</p>
<script src="https://gist.github.com/786661.js?file=safe_global.rb"></script><!--<code><pre>@con = Connection.new("localhost", 27017, :safe => {:w = 3}) @db = @con['myapp'] @collection = @db['users'] @collection.insert({:username => "banker"})</pre></code> --><p>Now, the insert will still use safe mode with w equal to 3, but it inherits this setting through the <code>@con</code>, <code>@db</code>, and <code>@collection</code> objects. A few more details on this can be found in the <a title="Write concern in Ruby" href="http://api.mongodb.org/ruby/current/file.WRITE_CONCERN.html">write concern docs</a>.</p>
<h3>JRuby</h3>
<p>One of the most exciting advances in the last few months is the driver’s special support for JRuby. Essentially, when you run the driver on JRuby, the BSON library uses a Java-based serializer, guaranteeing the best performance for the platform.</p>
<p>One of the big advantages to running on JRuby is its support for native threads. So if you’re building multi-threaded apps, you may want to take advantage of the driver’s built-in connection pooling. Whether you’re creating a <a title="Connection class" href="http://api.mongodb.org/ruby/current/Mongo/Connection.html">standard connection</a> or a <a title="Replica set connection docs" href="http://api.mongodb.org/ruby/current/Mongo/ReplSetConnection.html">replica set connection</a>, simply pass in a size and timeout for the thread pool, and you’re good to go.</p>
<p>Another relevant feature that’s slated for the next month is an asynchronous facade for the driver that uses the <a title="Reactor pattern at Wikipedia" href="http://en.wikipedia.org/wiki/Reactor_pattern">reactor pattern</a>. (This has been spearheaded, and is in fact used in production, by Chuck Remes. Thanks, Chuck!). You can track progress at the <a title="Ruby driver async branch" href="https://github.com/mongodb/mongo-ruby-driver/tree/async">async branch</a>.</p>
<h3>Rails and the Object Mappers</h3>
<p>Finally, a word about Rails and object mappers. If you’re a Rails user, then there’s a good chance that you don’t use the Ruby driver directly at all. Instead, you probably use one of the available object mappers.</p>
<p>The object mappers can be a great help, but do be careful. We’ve seen a number of users get burned because they don’t understand the data model being created. So the biggest piece of advice is to understand the underlying representation being built out by your object mapper. It’s all too easy to abuse the nice abstractions provided by the OMs to create unwieldy, inefficient mega-documents down below. <em>Caveat programator</em>.</p>
<p>That said, I get a lot of questions about which OM to use. Now, if you understand how the OM actually works, then it really shouldn’t matter which one you use. But not everyone has the time to dig into these code bases. So when I do recommend one, I recommend <a title="MongoMapper" href="http://mongomapper.com/">MongoMapper</a>. This is, admittedly, a bit of an aesthetic judgment, but I like the API and have found the software to be simple and reliable. Long-awaited docs for the projects are imminent, and we’ll <a title="MongodB on Twitter" href="http://twitter.com/#!/mongodb">tweet about them</a> once they’re available.</p>
<h3>What’s next</h3>
<p>If you want to know more about the Ruby driver, tune in to <a title="Ruby driver webcast" href="http://www.10gen.com/webinars/mongodb-ruby-2011">next week’s Ruby driver webcast</a>, where I’ll talk about everything in the post, plus some.</p>
<p>Finally, a big thanks to all those who have contributed to the driver, to the object mapper authors, and the all users of MongoDB with Ruby.</p>
<p>- Kyle Banker</p>";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:39:"http://blog.mongodb.org/post/2844804263";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:39:"http://blog.mongodb.org/post/2844804263";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Thu, 20 Jan 2011 14:15:00 -0500";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:1;a:6:{s:4:"data";s:0:"";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:1:{s:0:"";a:5:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:38:"Five New Replica Set Features in 1.7.x";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:3589:"<p>Here’s a rundown of some of the most useful features added recently.  These are all available in 1.7.4 and will, of course, be in 1.8.</p>
<ol>
<li>
<p><strong>Initial sync from a secondary</strong></p>
You can now set an <em>initialSync</em> source for each member, which controls where the new guy will sync from.  For example, if you wanted to add a new node and force it to sync from a secondary, you could do:
<pre>> rs.add({"_id" : num, "host" : hostname, "initialSync" : {"state" : 2}}) 
</pre>
<p>You can choose a sync source by its state (primary or secondary), _id, hostname, or up-to-date-ness.  For the last, you can specify a date or timestamp and the new member will choose a source that is at least that up-to-date.</p>
<p>By default, a new member will attempt to sync from a random secondary and, if it can’t find one, sync from the primary.  If it chooses a secondary, it will only use the secondary for its initial sync.  Once it’s ready to sync new data, it will switch over and use the primary for “normal” syncing.</p>
</li>
<li>
<p><strong>Slave delay</strong></p>
This option makes the slave postpone replaying operations from the master.  The delay can be specified in seconds in a member’s configuration:
<pre>> rs.add({"_id" : num, "host" : hostname, "slaveDelay" : 3600})
</pre>
</li>
<li>
<p><strong>Hidden</strong></p>
Hidden servers won’t appear in <code>isMaster()</code> results.  This also means that they will <em>not</em> be used if a driver automatically distributes reads to slaves.  A hidden server must have a priority of 0 (you can’t have a hidden primary).  To add a hidden member, run:
<pre>> rs.add({"_id" : num, "host" : hostname, "priority" : 0, "hidden" : true})
</pre>
</li>
<li>
<p><strong>Freeze a member</strong></p>
Replica set members abhor a vacuum and will immediately try to elect themselves if the primary disappears.  This can make maintenance or a planned failover difficult.  Freezing a member forces it to remain a secondary for a given number of seconds (defaults to 60).  This can be useful if you want to do some maintenance on the primary and don’t want an usurpers jumping in or you want to force a certain member to become the new primary.  To freeze a member, run:
<pre>> rs.freeze(3600)
</pre>
To unfreeze at any time:
<pre>> rs.freeze(0)
</pre>
</li>
<li>
<p><strong>Fast sync</strong></p>
<p>If you have a backup that’s reasonably up-to-date, you can bring up a new member quickly with a fast sync.  Start the new member <code>--dbpath</code> set to your backup and <code>--fastsync</code> (as well as <code>--replSet</code>, <code>--oplogSize</code>, and whatever else you usually specify).  Instead of copying all of the data from the master, it will just replay the latest operations.</p>
<p>You can check if a backup is recent enough to fast sync by connecting to the primary and running:</p>
<pre>> use local
> new Date(db.oplog.rs.find().sort({$natural:1}).limit(1).next()["ts"]["t"])
</pre>
If your backup is from <em>before</em> the date displayed, you can catch up to the master using fast sync.  If not, you’ll need to resync from scratch. </li>
</ol>
<p>There are lots more replica set features coming soon: authentication, syncing from secondaries beyond the initial sync, data center awareness, and more.  If there are any features you’d particularly like to see, be sure to <a href="https://jira.mongodb.org/secure/IssueNavigator.jspa?reset=true&mode=hide&pid=10000&sorter/order=DESC&sorter/field=priority&resolution=-1&component=10010">vote on the cases you care about</a>.</p>";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:39:"http://blog.mongodb.org/post/2388886125";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:39:"http://blog.mongodb.org/post/2388886125";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Mon, 20 Dec 2010 11:00:07 -0500";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:2;a:6:{s:4:"data";s:0:"";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:1:{s:0:"";a:5:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:36:"Archiving - a good MongoDB use case?";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:1299:"<p>Someone recently pointed out to me, rather insightfully, that MongoDB is a good fit for archival of <em>relational</em> data.  </p>
<p>I had not really considered this before, but it is a good point : flexible schemas are very helpful for archival.  How do we keep an archive of data, say, 10 years or more of data history, when over that time period the schema will undergo significant changes?  It is not so easy.</p>
<p>One approach would be to apply any schema changes from the online / operational database at the archival database too.  However, there are some issues.  First, the archival database may be huge, making schema migrations impractical.  But more importantly, these changes may not be what we want in an archive.  Imagine we decide to drop a column in the online db.  It may now be deprecated and unneeded.  However, a true and complete archive would still have that data.  Dropping the column in the archive is not what we want.</p>
<p>Document-oriented databases, with their flexible schemas, provide a nice solution.  We can have older documents which vary a bit from the newer ones in the archive.  The lack of homogeneity over time may mean that querying the archive is a little harder.  However, keeping the data is potentially much easier.</p>
<p>—dm</p>";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:39:"http://blog.mongodb.org/post/1200539426";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:39:"http://blog.mongodb.org/post/1200539426";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Mon, 27 Sep 2010 18:02:00 -0400";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:3;a:6:{s:4:"data";s:0:"";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:1:{s:0:"";a:5:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:20:"MongoDB 1.6 Released";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:3316:"<p>MongoDB 1.6.0 is the fourth stable major release (even numbers are “stable” : 1.0, 1.2, 1.4, …) and is the culmination of the 1.5 development series.</p>
<p><strong>Scale-out</strong></p>
<p>The focus of the 1.6 release is scale-out.  <a target="_blank" href="http://www.mongodb.org/display/DOCS/Sharding">Sharding</a> is now production-ready.  The combination of sharding and replica sets allows one to build out horizontally scalable data storage clusters with no single points of failure.</p>
<p>A single instance of mongod can be upgraded to a distributed cluster with zero downtime when the need arises.</p>
<p>A big thanks to all the 1.5.x beta testers of sharding (including <a target="_blank" href="http://www.foursquare.com">foursquare</a> and <a target="_blank" href="http://bit.ly">bit.ly</a> who have been using sharding in production for a while now).</p>
<p><strong>Replica Sets</strong> </p>
<p>Replica sets allow you to setup a high availability cluster with automatic fail over and recovery.  Replica pair users should, when convenient, migrate to replica sets.</p>
<p><strong>Other Improvements in v1.6</strong></p>
<ul>
<li>
<a target="_blank" href="http://www.mongodb.org/display/DOCS/Verifying+Propagation+of+Writes+with+getLastError">acknowledged replication</a>: The w option (and wtimeout) force writes to be propagated to N servers before returning success (works well with replica sets).</li>
<li>
<a href="http://www.mongodb.org/display/DOCS/Advanced+Queries#AdvancedQueries-%24or">$or</a> queries</li>
<li>Up to 64 indexes/collection</li>
<li>Improved concurrency</li>
<li><a title="$slice operator" href="http://www.mongodb.org/display/DOCS/Advanced+Queries#AdvancedQueries-%24sliceoperator">$slice operator</a></li>
<li>Support for UNIX domain sockets and IPv6</li>
<li>Windows service improvements</li>
<li>The C++ client is a separate tarball from the binaries</li>
</ul>
<p>Downloads: <a href="http://www.mongodb.org/display/DOCS/Downloads"><a href="http://www.mongodb.org/display/DOCS/Downloads">http://www.mongodb.org/display/DOCS/Downloads</a></a></p>
<p>Release Notes: <a href="http://www.mongodb.org/display/DOCS/1.6+Release+Notes"><a href="http://www.mongodb.org/display/DOCS/1.6+Release+Notes">http://www.mongodb.org/display/DOCS/1.6+Release+Notes</a></a></p>
<p><a href="http://jira.mongodb.org/secure/IssueNavigator.jspa?mode=hide&requestId=10107">Full change log</a></p>
<p>Please report any issues to <a href="http://groups.google.com/group/mongodb-user"><a href="http://groups.google.com/group/mongodb-user">http://groups.google.com/group/mongodb-user</a></a> (support forums) or <a href="http://jira.mongodb.org/"><a href="http://jira.mongodb.org/">http://jira.mongodb.org/</a></a> (bug/feature db).</p>
<p><strong>What’s Next</strong></p>
<p>Now that 1.6 is out, we’re going to be focusing on 1.8.  Help us prioritize features for this release by voting for your key needs at <a href="http://jira.mongodb.org/">jira.mongodb.org</a>.  The #1 feature queued for v1.8 is single server durability.</p>
<p><strong>More Information</strong></p>
<p>Please join 10gen CEO and Co-Founder Dwight Merriman for the webinar <a href="http://www.10gen.com/webinars/mongodb16">What’s New in MongoDB v1.6</a> on Tuesday, August 10 at 12:30pm ET / 9:30am PT.</p>";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:38:"http://blog.mongodb.org/post/908172564";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:38:"http://blog.mongodb.org/post/908172564";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Thu, 05 Aug 2010 12:28:00 -0400";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:4;a:6:{s:4:"data";s:0:"";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:1:{s:0:"";a:5:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:19:"Node.js and MongoDB";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:3373:"<p>Node.js is turning out to be a framework of choice for building real-time applications of all kinds, from analytics systems to chat servers to location-based tracking services. If you’re still new to Node, check out <a title="Node.js is genuinely exciting" href="http://simonwillison.net/2009/Nov/23/node/">Simon Willison’s excellent introductory post</a>. If you’re already using Node, you probably need a database, and you just might have considered using MongoDB.</p>
<p>The rationale is certainly there. Working with Node’s JavaScript means that MongoDB documents get their most natural representation — as JSON — right in the application layer. There’s also significant continuity between your application and the MongoDB shell, since the shell is essentially a JavaScript interpreter, so you don’t have to change languages when moving from application to database.</p>
<p><strong>Node.js MongodB Driver</strong></p>
<p>Especially impressive to us at 10gen has been the community support for Node.js and MongoDB. First, there’s Christian Kvalheim’s excellent <a title="MongoDB Node Native Driver" href="http://github.com/christkv/node-mongodb-native">mongodb-node-native project</a>, a non-blocking MongoDB driver implemented entirely in JavaScript using Node.js’s system libraries. The project is a pretty close port of the <a title="MongoDB Ruby Driver" href="http://www.mongodb.org/display/DOCS/Ruby+Language+Center">MongoDB Ruby driver</a>, making for an easy transition for those already used to the 10gen-supported drivers. If you’re just starting, there’s a helpful <a title="MongoDB Node Native Mailing List" href="http://groups.google.com/group/node-mongodb-native">mongodb-node-native mailing list</a>.</p>
<p><strong>Hummingbird</strong></p>
<p>Need a real-world example? Check out <a title="Hummingbird App" href="http://mnutt.github.com/hummingbird/">Hummingbird</a>, Michael Nutt’s real-time analytics app. It’s built on top of MongoDB using Node.js and the mongodb-node-native driver. Hummingbird, which is used in production at <a title="Gilt Groupe" href="http://www.gilt.com/">Gilt Groupe</a>, brings together an impressive array of technologies; it uses the <a title="Express.js" href="http://expressjs.com/">express.js</a> Node.js app framework and sports a responsive interface with the help of web sockets. Definitely worth checking out.</p>
<p><strong>Mongoose</strong></p>
<p>Of course, one of the admitted difficulties in working with Node.js is dealing with deep callback structures. If this poses a problem, or if you happen to want a richer data modeling library, then <a title="Mongoose" href="http://www.learnboost.com/mongoose/">Mongoose</a> is the answer. Created by <a title="Learnboost" href="http://www.learnboost.com/">Learnboost</a>, Mongoose sits atop mongodb-node-native, providing a nice API for modeling your application.</p>
<p><strong>Node Knockout</strong></p>
<p>All of this just to show that the MongoDB/Node.js ecosystem thrives. If you need a good excuse to jump into Node.js or MongoDB development, be sure to check out next month’s <a title="Node Knockout" href="http://nodeknockout.com/">Node Knockout</a>. It’s a weekend app competition for teams up to four, and <a title="Node Knockout Registration" href="http://nodeknockout.com/teams/new">registration is now open</a>. </p>";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:38:"http://blog.mongodb.org/post/812003773";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:38:"http://blog.mongodb.org/post/812003773";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Wed, 14 Jul 2010 15:49:00 -0400";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:5;a:6:{s:4:"data";s:0:"";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:1:{s:0:"";a:5:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:21:"Blog Contest Winners!";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:1107:"<p>We’re pleased to announce the winner’s of the MongoDB <a href="http://blog.mongodb.org/post/607112305/write-a-blog-post-on-mongodb-for-a-chance-to-win-a">blogging contest</a>!</p>
<p>Grand Prize</p>
<ul>
<li>
<a target="_blank" href="http://www.mattinsler.com/why-and-how-i-replaced-amazon-sqs-with-mongodb/">Why (and How) I Replaced Amazon SQS with MongoDB</a> - Matt Insler</li>
</ul>
<p>Runners Up</p>
<ul>
<li>
<a href="http://www.captaincodeman.com/2010/05/24/mongodb-azure-clouddrive/">Running MongoDb on Microsoft Windows Azure with CloudDrive</a> - Simon Green</li>
<li>
<a href="http://codesanity.net/2010/05/mongodb-codeigniter-logs/">Using MongoDB for CodeIgniter Logs</a> - Tom Schlick</li>
<li>
<a href="http://jbaruch.wordpress.com/2010/04/27/integrating-mongodb-with-spring-batch/">Integrating MongoDB with Spring Batch</a> - Baruch Sadogursky</li>
</ul>
<p>The winners should contact meghan@10gen.com to claim their prizes.</p>
<p>You check out all the awesome entries at <a href="http://mongodb.slinkset.com/">mongodb.slinkset.com</a></p>
<p>Thanks to everyone who submitted!</p>";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:38:"http://blog.mongodb.org/post/677516152";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:38:"http://blog.mongodb.org/post/677516152";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Tue, 08 Jun 2010 15:50:04 -0400";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:6;a:6:{s:4:"data";s:0:"";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:1:{s:0:"";a:5:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:24:"Highlights from MongoNYC";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:2263:"<p>On May 21, 10gen organized the second conference dedicated to MongoDB. Like MongoSF, MongoNYC included a great line-up of speakers. One of the more popular talks was Kyle Banker’s Schema Design session, which was so crowded that many attendees sat on the floor! Both the <a target="_blank" href="http://blip.tv/file/3704083">video</a> and <a target="_blank" href="http://www.slideshare.net/kbanker/mongodb-schema-design-mongony">slides</a> from the talk are now available. </p>
<p><img width="250" src="http://media.tumblr.com/tumblr_l3fwofB2dt1qzyevi.jpg"/> </p>
<p>Also interesting were the many talks on MongoDB production deployments. Kushal Dave, the CTO at Chartbeat, gave an excellent talk on how Chartbeat came to use MongoDB after trying many solutions to store historical data analytics (see <a target="_blank" href="http://bit.ly/chartbeat_mongodb">slides</a> & <a target="_blank" href="http://blip.tv/file/3701052">video</a>). Jay Ridgeway talked about bit.ly user history, which is auto-sharded using MongoDB (<a target="_blank" href="http://bit.ly/bitly_mongo">slides</a> & <a target="_blank" href="http://blip.tv/file/3704043">video</a>). Gilt Groupe demoed their real-time analytics tool <a target="_blank" href="http://mnutt.github.com/hummingbird/">Hummingbird</a>, which is built with MongoDB and node.js. Avery Rosen, the CTO of ShopWiki, wrote a recap of his talk “Finding a Swiss army data store” on the <a target="_blank" href="http://devblog.shopwiki.com/post/660499806/averys-talk-at-mongonyc">ShopWiki dev blog</a>.</p>
<p>Another big hit was Harry Heymann’s presentation on MongoDB at foursquare, the video of which is included below.</p>
<p><embed allowfullscreen="true" allowscriptaccess="always" height="355" width="425" type="application/x-shockwave-flash" src="http://blip.tv/play/AYHjoCYA"></embed></p>
<p>Videos from all the talks at MongoNYC are available at <a target="_blank" href="http://mongodb.blip.tv/">mongodb.blip.tv</a>.</p>
<p>Thanks for making the event such a success! We’re getting really excited about <a href="http://www.10gen.com/conferences/event_mongouk_18june10">MongoUK</a> and <a href="http://www.10gen.com/conferences/event_mongofr_21june10">MongoFR</a>, which are only a few weeks away.</p>";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:38:"http://blog.mongodb.org/post/673306445";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:38:"http://blog.mongodb.org/post/673306445";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Mon, 07 Jun 2010 11:15:03 -0400";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:7;a:6:{s:4:"data";s:0:"";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:1:{s:0:"";a:6:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:35:"Holy Large Hadron Collider, Batman!";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:3633:"<p><img src="http://media.tumblr.com/tumblr_l3fxep9cOJ1qbihth.jpg"/></p>
<p><a href="http://www.lns.cornell.edu/~vk/">Valentin Kuznetsov</a> just presented a paper at the <a href="http://www.iccs-meeting.org/">International Conference on Computational Science</a> on CERN’s use of MongoDB for Large Hadron Collider data.  The paper, <em>The CMS Data Aggregation System</em>, is available as a PDF at <a href="http://www.sciencedirect.com/science?_ob=ArticleURL&_udi=B9865-506HM1Y-63&_user=10&_coverDate=05/31/2010&_alid=1599887349&_rdoc=2&_fmt=high&_orig=search&_origin=search&_zone=rslt_list_item&_cdi=59117&_sort=r&_st=13&_docanchor=&view=c&_ct=9&_acct=C000050221&_version=1&_urlVersion=0&_userid=10&md5=3cac4c1c78f95ee5d0e3f274a6209537&searchtype=a">ScienceDirect</a>.</p>
<h4>A summary</h4>
<p>“CMS” stands for <a href="http://cms.web.cern.ch/cms/index.html">Compact Muon Solenoid</a>, a general-purpose particle physics detector built on the Large Hadron Collider.  The CMS project posted a few <a href="http://cms.web.cern.ch/cms/Education/ComicBook/index.html">comics</a> which provide a nice, simple (if somewhat cheesy) explanation of what the CMS/LHC does.</p>
<p>The LHC generates massive amounts of data of all different varieties, which is distributed across a worldwide grid.  It sends status messages to some of the computers, job monitoring info to other computers, bookkeeping info still elsewhere, and so on.</p>
<p>This means that each location has specialized queries it can do on the data it has, but up until now it’s been very difficult to query across the whole grid.  Enter the Data Aggregation System, designed to allow anything to be queried across all of the machines.</p>
<h4>How it works</h4>
<p>The aggregation system uses MongoDB as a cache.  It checks if Mongo has the aggregation the user is asking for and, if it does, returns it, otherwise the system does the aggregation and saves it to Mongo.</p>
<p>They query the system using a simple, SQL-like language which they transform into a MongoDB query.  So, something like <code>file="abc", run>10</code> becomes <code>{"file" : "abc", "run" : {"$gt" : 10}}</code>.  (It’s not the same as SQL, but the code for this might be interesting to people who want to use SQL queries with MongoDB.)</p>
<p>If the cache does not contain the requested query, the system iterates over all of the places in the world that could have this information and queries them, gathering their results.  It then merges all of the results, doing a sort of “group by” operation based on predefined identifying key and inserts the aggregated information into the cache.</p>
<p>It was built using the <a href="http://www.mongodb.org/display/DOCS/Python+Language+Center">Python driver</a>.</p>
<h4>Goals</h4>
<p>They’re looking forward to field testing it and horizontally scaling the system with sharding.  As this is a general grid aggregation/querying tool, they’re also interested in applying it to problems outside of the LHC and CERN.</p>
<p>We wish them luck and hope they’ll keep us informed on future progress!</p>
<p><em>Edit: the slides from Valentin’s presentation are available at <a href="http://www.slideshare.net/vkuznet/das-iccs-2010"><a href="http://www.slideshare.net/vkuznet/das-iccs-2010">http://www.slideshare.net/vkuznet/das-iccs-2010</a></a>.</em></p>
<em>Kristina Chodorow maintains the MongoDB PHP and Perl drivers.  She blogs at <a href="http://www.snailinaturtleneck.com"><a href="http://www.snailinaturtleneck.com">www.snailinaturtleneck.com</a></a> and tweets as <a href="http://www.twitter.com/kchodorow">@kchdorow</a>.</em>";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:38:"http://blog.mongodb.org/post/660037122";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:38:"http://blog.mongodb.org/post/660037122";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Thu, 03 Jun 2010 10:53:00 -0400";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:8:"category";a:5:{i:0;a:5:{s:4:"data";s:4:"CERN";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}i:1;a:5:{s:4:"data";s:7:"Caching";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}i:2;a:5:{s:4:"data";s:21:"Compact Muon Solenoid";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}i:3;a:5:{s:4:"data";s:21:"Large Hadron Collider";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}i:4;a:5:{s:4:"data";s:11:"aggregation";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:8;a:6:{s:4:"data";s:0:"";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:1:{s:0:"";a:5:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:72:"Write a blog post on MongoDB for a chance to win a ticket to OSCON 2010!";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:2257:"<p>10gen has a ticket to <a href="http://www.oscon.com/oscon2010">OSCON</a> that we’d like to give to a MongoDB user.</p>
<p><span><em>How to Enter</em></span></p>
<ul>
<li>Write a blog post.  It has to be about MongoDB, but within that it can be anything: a how-to, an experience you had, a review, a rant, a rave, a technical piece, a humorous piece… whatever you want.</li>
<li>Post your blog at <a href="http://mongodb.slinkset.com/">mongodb.slinkset.com</a> and include your contact information in the description.  You must submit by June 1st.  Your post must be publicly accessible (not behind a pay wall or members-only site).</li>
<li>We’ll announce the winners June 7th.</li>
</ul>
<p><span><em>Prizes</em></span></p>
<p>Grand prize</p>
<ul>
<li>1 ticket to OSCON</li>
<li>MongoDB swag package: shirt, coffee mug, and stickers</li>
<li>Option to do a guest post on blog.mongodb.org</li>
</ul>
<p>There will also be 3 runners up who get MongoDB mugs and stickers, as well as mentions/links on blog.mongodb.org.</p>
<p><span><em>Judging</em></span></p>
<ul>
<li>50% public judging - vote up your favorite blogs at <a href="http://mongodb.slinkset.com/">mongodb.slinkset.com</a>
</li>
<li>50% will be done by a panel of MongoDB core developers.  We’ll be looking for a really great piece on MongoDB, a piece that is really interesting.  Please don’t forget to proofread!</li>
</ul>
<p><span><em>Rules</em></span></p>
<ul>
<li>It must be written.  No screencasts or podcasts, sorry.  You can use images but no audio or video are allowed.</li>
<li>It must be posted at <a href="http://mongodb.slinkset.com/">mongodb.slinkset.com</a>, and include your contact information in the description.</li>
<li>Entries will be accepted between Monday May 17 and Tuesday June 1st.</li>
<li>You must provide for your own travel, we’re just giving you the OSCON ticket. You have to get your own plane ticket, hotel reservation, visa (if you’re outside the US) etc.</li>
</ul>
<p>If you don’t have a blog, you can get one in about 3 seconds from <a href="http://posterous.com/">Posterous</a> or <a href="http://www.tumblr.com/">tumblr</a>.  Make sure you’re identifiable if you go this route!</p>
<p>Good luck everyone!</p>";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:38:"http://blog.mongodb.org/post/607112305";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:38:"http://blog.mongodb.org/post/607112305";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Mon, 17 May 2010 11:08:22 -0400";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:9;a:6:{s:4:"data";s:0:"";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:1:{s:0:"";a:5:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:65:"MongoSF Slides & Video; Discounts on upcoming MongoDB conferences";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:1739:"<p>MongoSF, the first full-day conference dedicated to MongoDB, featured 35+ sessions and even produced a few surprises along the way. Over 200 people attended the April 30 conference. Slides and video from many sessions now available on the <a target="_blank" href="http://www.10gen.com/event_mongosf_10apr30">10gen website</a>.</p>
<p>The Sharding presentation was one of the major highlights of the event. Eliot Horowitz, the CTO of 10gen, demoed a 25-node cluster on EC2. Check out the <a target="_blank" href="http://www.10gen.com/event_mongosf_10apr30#sharding">video</a> of the session.</p>
<p>MongoHQ made a major announcement during their session, launching their add-on to all Heroku users as a public beta. For more details, check out the <a target="_blank" href="http://blog.heroku.com/archives/2010/4/30/mongohq_add_on_public_beta">Heroku blog</a>.</p>
<p>The conference was held at <a target="_blank" href="http://www.bentlyreserve.com/">Bently Reserve</a>, where we hope many future tech conferences will take place. Not only is the venue beautiful and historic, but it is fully equipped for conferences. The wireless actually worked!</p>
<p><img src="http://media.tumblr.com/tumblr_l27gj5Vfku1qzyevi.jpg"/><br/><em>The main banking hall at Bently Reserve at 8:30 on the morning of MongoSF - it filled up shortly thereafter!</em></p>
<p>More MongoDB conferences coming soon! Use the discount code “blog” when registering.</p>
<p><a href="http://www.10gen.com/event_mongony_10may21">MongoNYC</a> - Friday, May 21<br/><a href="http://www.10gen.com/conferences/event_mongouk_18june10">MongoUK</a> - Friday, June 18 <br/><a href="http://www.10gen.com/conferences/event_mongofr_21june10">MongoFR</a> - Monday, June 21 </p>";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:38:"http://blog.mongodb.org/post/586818965";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:38:"http://blog.mongodb.org/post/586818965";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Mon, 10 May 2010 09:40:17 -0400";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:10;a:6:{s:4:"data";s:0:"";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:1:{s:0:"";a:5:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:47:"MongoDB Conferences in London and Paris in June";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:1139:"<p>MongoDB conferences are coming to Europe! <a target="_blank" href="http://www.10gen.com/conferences/event_mongouk_18june10">MongoUK</a> is on Friday, June 18 at Skills Matter and <a target="_blank" href="http://www.10gen.com/conferences/event_mongofr_21june10">MongoFR</a> is on Monday, June 21 at La Cantine. Each conference will feature sessions from the 10gen team on schema design, replication, sharding, indexing, and map/reduce. In addition, attendees will learn about MongoDB in production through presentations by companies like Boxed Ice, Silentale, OCW Search, and Novelys.</p>
<p>10gen is organizing MongoFR in conjunction with the NoSQL Paris User Group, with the help of NoSQL enthusiast Tim Anglade. (Pour les francophones : nous devons vous avertir que certaines sessions de MongoFR seront en anglais et d’autres en français. La journée sera également suivie d’une rencontre spéciale de l’UG — entrée gratuite à partir de 19h à La Cantine. Pour plus d’informations en français, contactez timanglade@gmail.com par email ou @timanglade sur Twitter.)</p>
<p>We look forward to seeing you there!</p>";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:38:"http://blog.mongodb.org/post/573215976";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:38:"http://blog.mongodb.org/post/573215976";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Wed, 05 May 2010 06:00:00 -0400";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:11;a:6:{s:4:"data";s:0:"";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:1:{s:0:"";a:5:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:27:"MongoDB Q1 Download Numbers";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:697:"<p><span> </span></p>
<p>The MongoDB team is very excited about how the developer community is building around MongoDB, and we wanted to share some numbers.</p>
<p>These are download numbers for the core server for January through March.  It is exactly the number of downloads of the core database from downloads.mongodb.org minus all bots (all known plus anything with bot in the user-agent) and all other crawlers we determine.  We use these numbers internally, so we do try and keep them accurate.</p>
<pre>January    15647
February  23226
March      37144
</pre>
<p>We are very excited about these numbers — please spread the word and help us continue growth of MongoDB!</p>
<p>-Eliot</p>";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:38:"http://blog.mongodb.org/post/550850783";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:38:"http://blog.mongodb.org/post/550850783";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Mon, 26 Apr 2010 10:32:11 -0400";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:12;a:6:{s:4:"data";s:0:"";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:1:{s:0:"";a:6:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:55:"On Distributed Consistency - Part 6 - Consistency Chart";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:2624:"<p>See also:</p>
<ul>
<li><a href="http://blog.mongodb.org/post/475279604/on-distributed-consistency-part-1">Part 1 - Introduction and CAP</a></li>
<li><a href="http://blog.mongodb.org/post/498145601/on-distributed-consistency-part-2-some-eventual">Part 2 - Eventual Consistency</a></li>
<li><a href="http://blog.mongodb.org/post/505822180/on-distributed-consistency-part-3-network">Part 3 - Network Partitions</a></li>
<li><a href="http://blog.mongodb.org/post/516567520/on-distributed-consistency-part-4-multi-data-center">Part 4 - Multi Data Center</a></li>
<li><a href="http://blog.mongodb.org/post/520888030/on-distributed-consistency-part-5-many-writer">Part 5 - Multi Writer Eventual Consistency</a></li>
</ul>
<p>The following diagram (click for large version) shows the various consistency models that have been discussed in this blog post series.  Stronger consistency modes generally meet the requirements of weaker modes, and are thus shown as subsets in this Venn-like diagram. </p>
<p>Keep in mind that for many products, consistency is tunable: a product doesn’t necessarily belong to a particular rectangle, but a given operation certainly does.</p>
<p><a title="click for larger image" href="http://i44.tinypic.com/2h3vb6p.png"><img align="middle" src="http://i44.tinypic.com/33af3i9.png" width="320" height="240"/></a></p>
<ul>
<li>Eventual Consistency - eventual consistency as defined by Amazon in the Dynamo paper.</li>
<li>
<a href="http://blog.mongodb.org/post/498145601/on-distributed-consistency-part-2-some-eventual">Monotonic read consistency</a> - a stricter form of eventual consistency.</li>
<li>
<a href="http://blog.mongodb.org/post/498145601/on-distributed-consistency-part-2-some-eventual">Read-your-own-writes</a> consistency - a stricter form of eventual consistency.</li>
<li>MRC + RYOW - a system with both monotonic read plus read-your-own-writes properties.  A master-master replication system, where a given client always interacts with a single master, would have these properties.</li>
<li>Immediate Consistency - a system which is immediately consistent but which does not support atomic operations.  Strict quorum systems, where R+W>N, meet this criteria (and theoretically could do more, depending on the design).</li>
<li>Strong Consistency - a system which supports read/write atomic operations on single data entities.  This is the default mode for MongoDB.</li>
<li>Full Transactions - <a href="https://shop.oracle.com/pls/ostore/f?p=ostore:product:2299037659209236::NO:RP,3:P3_LPI,P3_PROD_HIER_ID:4509382199341805719938,4509958287721805720011">Oracle</a>!</li>
</ul>";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:38:"http://blog.mongodb.org/post/523516007";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:38:"http://blog.mongodb.org/post/523516007";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Thu, 15 Apr 2010 11:32:12 -0400";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:8:"category";a:5:{i:0;a:5:{s:4:"data";s:12:"venn diagram";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}i:1;a:5:{s:4:"data";s:20:"eventual consistency";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}i:2;a:5:{s:4:"data";s:18:"strong consistency";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}i:3;a:5:{s:4:"data";s:5:"nosql";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}i:4;a:5:{s:4:"data";s:11:"cap theorem";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:13;a:6:{s:4:"data";s:0:"";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:1:{s:0:"";a:6:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:70:"On Distributed Consistency - Part 5 - Many Writer Eventual Consistency";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:6116:"<p>See also:</p>
<ul>
<li><a href="http://blog.mongodb.org/post/475279604/on-distributed-consistency-part-1">Part 1 - Introduction and CAP</a></li>
<li><a href="http://blog.mongodb.org/post/498145601/on-distributed-consistency-part-2-some-eventual">Part 2 - Eventual Consistency</a></li>
<li><a href="http://blog.mongodb.org/post/505822180/on-distributed-consistency-part-3-network">Part 3 - Network Partitions</a></li>
<li><a href="http://blog.mongodb.org/post/516567520/on-distributed-consistency-part-4-multi-data-center">Part 4 - Multi Data Center</a></li>
<li><a href="http://blog.mongodb.org/post/523516007/on-distributed-consistency-part-6-consistency-chart">Part 6 - Consistency Chart</a></li>
</ul>
<p>In <a>part 2</a> we primarily discussed “single writer” eventual consistency.  Here we will discuss many-writer, and define that term more precisely.</p>
<p>By many-writer, we mean a system where different data servers can receive writes concurrently (and asynchronously).  Examples of many-writer eventually consistent systems include</p>
<ul>
<li>Amazon Dynamo</li>
<li>CouchDB master-master replication</li>
</ul>
<p>With multi-writer eventual consistency, we need to address the phenomenon of conflicting writes. Writes to two servers at the same time may be updates for the same object.  We must resolve the conflict in a way that is acceptable for the use case in question.  Some ways to do this are:</p>
<ul>
<li>last write wins</li>
<li>programmatic merge</li>
<li>commutative operations</li>
</ul>
<p><strong>Last Write Wins</strong></p>
<p>Last write wins is a popular default in many systems. If we receive an operation that is older, we simply ignore it.  In a distributed system the definition of “last” is hard as clocks can’t be perfectly synchronized.  Thus many systems use <a>vector clocks</a>.</p>
<p><u>Inserts</u></p>
<p>Surprisingly, a traditional insert operation is tricky with many writers. Consider these operations performed at about the same time at different servers:</p>
<pre>op1: insert( { _id : 'joe', age : 30 } )
op2: insert( { _id : 'joe', age : 33 } )</pre>
<p>If we naively apply these two operations in any order, we get an inconsistent result.  insert typically means:</p>
<pre>if( !already_exists(x._id) ) then set( x );</pre>
<p>However, with eventual consistency we do not have real-time global state.  Checking already_exists() is thus hard.</p>
<p>The best solution is to not support insert, but rather set() - i.e. “set a new value”.  Sometimes this is called an upsert.  Then, if we have last-write-wins semantics, everything is fine.</p>
<p><u>Deletes</u></p>
<p>Deletes require special handling in cases of object <em>rebirth</em>.  Consider this sequence:</p>
<pre>op1: set( { _id : 'joe', age : 40 } }
op2: delete( { _id : 'joe' } )
op3: set( { _id : 'joe', age : 33 } )</pre>
<p>If op2 and op3 are reversed in execution order, we would have a problem.  Thus we need to remember the delete for a while, and apply last-operation-wins semantics.  Some products call the remembrance of the delete a <em>tombstone</em>.</p>
<p><u>Updates</u></p>
<p>Updates have a similar issue as insert, so for updates, we use the set() operation we described above instead.</p>
<p>Note that <a>partial object updates</a> can be tricky to replicate efficiently.  Consider a set() operation where we wish to update a single field:</p>
<p>  update users set age=40 where _id=’joe’</p>
<p>This is no problem with eventual consistency if we replicate a full copy of the object.  However, what if the user object was 1MB in size?  It would be really nice to just send the new age field and the _id, rather than the whole object.  However, this is difficult.  Consider:</p>
<pre>op1: update users set age=40 where _id='joe'
op2: update users set state='ca' where _id='joe'</pre>
<p>Wen can’t simply replicate the partial update and use last-write-wins; the database will need more sophistication to handle this efficiently.</p>
<p><strong>Programmatic Merge</strong></p>
<p>Last-write-wins is great, but is not always sufficient.  Having the client application resolve the conflict via a merge is a fine alternative.  Let’s consider an example mentioned in the Amazon Dynamo paper: manipulations of shopping carts.  With eventual consistency it would not be safe to do something like:</p>
<pre>update cart set this[our_sku].qty=1 where _id='joe'</pre>
<p>If there are multiple manipulations of the cart, some may get lost using last-write-wins.  Instead, the Dynamo paper talks of storing the operations in the cart object, rather than the actual data state.  We could store something like:</p>
<pre>update cart append { time : now(), op : 'addToCart', sku : our_sku, qty : 1 }
  where _id='joe'</pre>
<p>When a conflict occurs, cart objects can be merged.  We do not lose any operations.  When it is time to check out, we replay all the operations, which might include quantity adjustments and removes from cart.  After replay we have the final cart state.</p>
<p>Note the above example uses a timestamp field — in a real system a vector clock might be used to order the operations in the cart.</p>
<p>It’s interesting to note that not only have we avoided conflicts, we are also able to do operations where atomicity would be required.</p>
<p><strong>Commutative Operations</strong></p>
<p>If all operations are commutative (more precisely, <a href="http://en.wikipedia.org/wiki/Fold_(higher-order_function)">foldable</a>), we will never have any conflicts.  Operations can simply be applied in any order, and the result is the same.  For example:</p>
<pre>// x starts as { }
x.increment('a', 1);
x.increment('a', 3);
x.addToSet('b', 'foo');
x.addToSet('b', 'bar');
result: { a : 4, b : {bar,foo} }

// x starts as { }
x.addToSet('b', 'bar');
x.increment('a', 3);
x.increment('a', 1);
x.addToSet('b', 'foo');
result: { a : 4, b : {bar,foo} }</pre>
<p>Note however that composition of addToSet and increment would not be foldable; thus, we have to use only one or the other for a particular field of the object.</p>";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:38:"http://blog.mongodb.org/post/520888030";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:38:"http://blog.mongodb.org/post/520888030";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Wed, 14 Apr 2010 10:18:00 -0400";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:8:"category";a:3:{i:0;a:5:{s:4:"data";s:20:"eventual consistency";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}i:1;a:5:{s:4:"data";s:7:"merging";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}i:2;a:5:{s:4:"data";s:19:"conflict resolution";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:14;a:6:{s:4:"data";s:0:"";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:1:{s:0:"";a:6:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:55:"On Distributed Consistency - Part 4 - Multi Data Center";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:5007:"<p><span> </span></p>
<p>See also:</p>
<ul>
<li><a href="http://blog.mongodb.org/post/475279604/on-distributed-consistency-part-1">Part 1 - Introduction and CAP</a></li>
<li><a href="http://blog.mongodb.org/post/498145601/on-distributed-consistency-part-2-some-eventual">Part 2 - Eventual Consistency</a></li>
<li><a href="http://blog.mongodb.org/post/505822180/on-distributed-consistency-part-3-network">Part 3 - Network Partitions</a></li>
<li><a href="http://blog.mongodb.org/post/520888030/on-distributed-consistency-part-5-many-writer">Part 5 - Multi Writer Eventual Consistency</a></li>
<li><a href="http://blog.mongodb.org/post/523516007/on-distributed-consistency-part-6-consistency-chart">Part 6 - Consistency Chart</a></li>
</ul>
<p>Eventual consistency makes multi-data center data storage easier.  There are reasons eventual consistency is helpful for multi-data center that are unrelated to availability and CAP.  And as mentioned in <a href="http://blog.mongodb.org/post/505822180/on-distributed-consistency-part-3-network">Part 3</a>, some common types of network partitions, such as loss of an entire data center, are actually <a href="http://i40.tinypic.com/30rxiyu.jpg">trivial network partitions</a> and may not even effect availability anyway.</p>
<p>Here are a few architectures for multi-data center data storage:</p>
<ul>
<li>DR</li>
<li>Single Region</li>
<li>Local reads, remote writes</li>
<li>Intelligent Homing</li>
<li>Eventual consistency</li>
</ul>
<p><strong>DR</strong></p>
<p>By DR we mean a traditional disaster recovery / business continuity architecture.  It’s pretty simple: we serve everything from one data center, with replication to a secondary facility that is offline.  In a failure we cut over.</p>
<p>Availability can be quite high in this model as on any issue with the first data center, including internal network partitions, we cut over, and with the whole first data center disabled, the partition is trivial.</p>
<p>This model works fine with strong consistency.</p>
<p><strong>Multi Data Center, Single Region</strong></p>
<p>This option is analogous to using multiple data centers within a single region.  Amazon and DoubleClick have used this scheme in the past.  We have multiple data centers, physically separated, but all within one region (such as the Northwest).  The latency between data centers is then reasonable: if we stay within a 150 mile radius, we can have round trip times of around 5ms.  We might have a fiber ring among say, 3 or 4 data centers.  As the latency is reasonable, for many problems, a WAN operation here is fine.  With a ring topology, a non-trivial network partition is unlikely.</p>
<p>Single region is useful both for strong consistent and eventually consistent architectures.  With a Dynamo style product, when N=W or N=R, this is a good option, as otherwise when using multiple data centers we will have a long wait time to confirm remote writes.</p>
<p><strong>Local Reads, Remote Writes</strong></p>
<p>For read-heavy use cases, this is a good option.  Here we read eventually consistent data (easy with most database products including RDBMS systems) but do all writes back to the master facility over the WAN.  A dynamo style system in multiple data centers with a very high W value and low R value can be thought of this way also.</p>
<p>This pattern would work great for traditional content management: publishing is infrequent and reading is very frequent.</p>
<p>Using a Content Delivery Network (CDN), with a centralized origin web site serving dynamic content, is another example.</p>
<p><strong>Intelligent Homing</strong></p>
<p>We discussed “Intelligent Homing” a bit in <a href="http://blog.mongodb.org/post/505822180/on-distributed-consistency-part-3-network">Part 3</a>.  The idea is to store the master copy of a given data entity near its user.</p>
<p>This model works quite well if data correlates with the user, such as the user’s profile, inbox, etc.</p>
<p>We have fast locally confirmed writes.  If a data center goes completely down, we could still fail over master status to somewhere else which has a replica.</p>
<p><strong>Eventual consistency</strong></p>
<p>Many-writer eventual consistency gives us two benefits with multiple data centers:</p>
<ul>
<li>higher availability in the face of network outages;</li>
<li>fast locally confirmed writes</li>
</ul>
<p>In the diagram below, a client of a dynamo-style system writes the data to four servers (N=4).  However, it only awaits confirmation of the writes from two servers in its local data center, to keep write confirmation latency low.</p>
<p><img width="320" height="240" src="http://i43.tinypic.com/2dbtgg5.png"/></p>
<p>Note however that if R+W > N, we can’t have both fast local reads and writes at the same time if all the data centers are equal peers.</p>
<p><strong>Combinations</strong></p>
<p>Combinations often make sense.  For example, it’s common to mix DR and Read Local Write Remote.</p>";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:38:"http://blog.mongodb.org/post/516567520";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:38:"http://blog.mongodb.org/post/516567520";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Mon, 12 Apr 2010 18:01:00 -0400";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:8:"category";a:2:{i:0;a:5:{s:4:"data";s:10:"datacenter";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}i:1;a:5:{s:4:"data";s:5:"nosql";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:15;a:6:{s:4:"data";s:0:"";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:1:{s:0:"";a:5:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:56:"On Distributed Consistency - Part 3 - Network Partitions";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:4585:"<p>See also:</p>
<ul>
<li><a href="http://blog.mongodb.org/post/475279604/on-distributed-consistency-part-1">Part 1 - Introduction and CAP</a></li>
<li><a href="http://blog.mongodb.org/post/498145601/on-distributed-consistency-part-2-some-eventual">Part 2 - Eventual Consistency</a></li>
<li><a href="http://blog.mongodb.org/post/516567520/on-distributed-consistency-part-4-multi-data-center">Part 4 - Multi Data Center</a></li>
<li><a href="http://blog.mongodb.org/post/520888030/on-distributed-consistency-part-5-many-writer">Part 5 - Multi Writer Eventual Consistency</a></li>
<li><a href="http://blog.mongodb.org/post/523516007/on-distributed-consistency-part-6-consistency-chart">Part 6 - Consistency Chart</a></li>
</ul>
<p>It’s fascinating that the formal theorem statement for CAP, in the first <a href="http://lpd.epfl.ch/sgilbert/pubs/BrewersConjecture-SigAct.pdf">proof</a> (that I know of), doesn’t use the word partition!</p>
<p><strong>Theorem 1</strong> <em>It is impossible in the asynchronous network model to implement a read/write data object that guarantees the following properties:</em><br/><em>• Availability</em><br/><em>• Atomic consistency in all fair executions (including those in which messages are lost).</em></p>
<p>That said, let’s talk about partitions, as “messages lost…in the asynchronous network model” is directly analogous.</p>
<p>Let’s look at an example:</p>
<p><a href="http://i39.tinypic.com/wundjn.jpg"><img src="http://i39.tinypic.com/30aykvr.png"/></a></p>
<p>In our diagram above, the network is partitioned.  The left and right halves (perhaps these correspond say to two continents) cannot communicate at all.  Four clients and four data server nodes are shown in the diagram.  So what are our options?</p>
<ol>
<li>Deny all writes.  If we deny all writes when the network is partitioned, we can still read fully consistent data on both sides.  So this is one option.  We give up write availability, and keep consistency.</li>
<li>Allow writes on one side.  Via some sort of consensus mechanism, we could let one side of the partition “win” and have a master (as shown by the “M” in the diagram).  In this case, reads and writes could occur on that side.  On the other non-master partitions, we could either (a) be strict and allow no operations, or (b) allow eventually consistent reads, but no writes.  So in this situation we have full consistency in one partition, and partial operation in all others.</li>
<li>Allow reads and writes in all partitions.  Here, we keep availability, but we must sacrifice strong consistency.  One partition will not see the operations and state from the other until the network is restored.  Once restored, we will need to a method to merge operations that occurred while disconnected.</li>
</ol>
<p>A mitigation technique also comes to mind.  Suppose a particular client C has a much higher probability of needing an entity X than other clients.  If we store the master copy of X on a server close to C, we increase the probability that C can read and write X in option (2) above.  Let’s call this “intelligent homing”.  A real world example of this would be to “store master copies of data for east coast users on servers on the east coast”.  Intelligent homing doesn’t solve our problems, but would likely significantly decrease their frequency — that’s good, we just want more nines anyway.</p>
<p>Hopefully the above is a good informal “proof” of CAP.  It really is pretty simple.</p>
<p><strong>Trivial Network Partitions</strong></p>
<p>Many common network partitions are what we might term <em>trivial</em>.  Let’s consider from the perspective of option (2) above. We define a <em>trivial network partition</em> is one such that on all non-master partitions, there are either</p>
<ul>
<li>no live clients at all, or </li>
<li>no servers at all</li>
</ul>
<p>For example, if we have many data centers and our clients are Internet web browsers, and one of our data centers goes completely dark (and we have more left), that is a trivial network partition (we assume here that we can fail over master status in such a situation).  Likewise, losing a single rack in its entirety is often a trivial network partition.</p>
<p><a href="http://i40.tinypic.com/30rxiyu.jpg"><img src="http://i43.tinypic.com/9rlwdz.png"/></a></p>
<p>In these situations, we can still be consistent and available.  (Well, for the partitioned client, we are unavailable, but that is of course a certainty if it cannot reach any servers anywhere.)</p>";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:38:"http://blog.mongodb.org/post/505822180";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:38:"http://blog.mongodb.org/post/505822180";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Thu, 08 Apr 2010 10:46:00 -0400";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:16;a:6:{s:4:"data";s:0:"";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:1:{s:0:"";a:5:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:69:"On Distributed Consistency - Part 2 - Some Eventual Consistency Forms";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:5410:"<p>See Also</p>
<ul>
<li><a href="http://blog.mongodb.org/post/475279604/on-distributed-consistency-part-1">Part 1 - Introduction and CAP</a></li>
<li><a href="http://blog.mongodb.org/post/505822180/on-distributed-consistency-part-3-network">Part 3 - Network Partitions</a></li>
<li><a href="http://blog.mongodb.org/post/516567520/on-distributed-consistency-part-4-multi-data-center">Part 4 - Multi Data Center</a></li>
<li><a href="http://blog.mongodb.org/post/520888030/on-distributed-consistency-part-5-many-writer">Part 5 - Multi Writer Eventual Consistency</a></li>
<li><a href="http://blog.mongodb.org/post/523516007/on-distributed-consistency-part-6-consistency-chart">Part 6 - Consistency Chart</a></li>
</ul>
<p>In <a href="http://blog.mongodb.org/post/475279604/on-distributed-consistency-part-1">Part 1</a> we discussed C-class and A-class behaviors.  For A-class, we need to weaken consistency constraints.  This does not mean the system need be completely inconsistent, but it does mean we will need to relax the consistency model to some extent.</p>
<p>Amazon popularized the concept of “Eventual Consistency”.  <a href="http://queue.acm.org/detail.cfm?id=1466448">Their definition</a> is: </p>
<p><em>the storage system guarantees that if no new updates are made to the object, eventually all accesses will return the last updated value.</em></p>
<p>This is not new, but it is great to have the concept formalized/popularized.  A few examples of eventually consistent systems:</p>
<ol>
<li>DNS (mentioned in the above paper)</li>
<li>Asynchronous master/slave replication on an RDBMS (also on MongoDB)</li>
<li>memcached in front of mysql, caching reads</li>
</ol>
<p>Many (not all) traditional examples that come to mind have eventually consistent reads, but a single writer (by “single writer”, we mean a data server, not the clients).  Things get more interesting — and complex — with when there are many writers.  Amazon Dynamo is an example of a “many writer eventually consistent” system.  All of the above are perhaps “single writer eventually consistent”.</p>
<p>One other traditional technology worth noting is message queues.  It has properties reminiscent of eventual consistency.</p>
<p><strong>Forms of Consistency</strong></p>
<p>Let’s look at a particular example.  Consider a system using MongoDB in the following configuration:</p>
<p><img src="http://i41.tinypic.com/35lw00x.jpg" height="227" width="319" align="middle"/></p>
<p>“master”, “slave”, and “slave” could be mongod instances for example — or other databases with asynchronous replication.  Clients randomly read from any slave for a given query, and always write to the master.  Two slaves and two clients are shown, but let’s assume each of those scale out.</p>
<p>This sort of system we term “single writer eventual consistency”.  So what are its properties?  (1) A client could read stale data. (2) The client could see out-of-order write operations.</p>
<p>Let’s suppose we are storing some entity <em>x</em> in the datastore.  Let’s assume entities have an initial value of zero.  There are a series of writes to x by clients:</p>
<p>  W(x=3), W(x=7), W(x=5)</p>
<p>Because the system is eventually consistent, if writes to x stop at some point, we know we will eventually read 5 — that is, R(x==5).  However in the short term a client might  for example see:</p>
<p>  R(x==7), R(x==0), R(x==5), R(x==3)</p>
<p>(Note more nodes than 2 slaves are needed for this example behavior.)</p>
<p>So this is our weakest form of consistency - eventually consistent with out of order reads in the short term. </p>
<p>We can make this stronger.  Consider the <a href="http://compoundthinking.com/blog/index.php/2009/07/16/turbogears-on-sourceforge/">SourceForge</a> mongodb configuration (<a href="http://compoundthinking.com/blog/wp-content/uploads/2009/07/sfconsume.png">larger diagram here</a>).  This configuration is eventually consistent, but we will not see the result of writes out of order.  It provides <em>monotonic read consistency</em>.</p>
<p><a title="larger version of image" href="http://compoundthinking.com/blog/wp-content/uploads/2009/07/sfconsume.png"><img src="http://compoundthinking.com/blog/wp-content/uploads/2009/07/sfconsume.png" height="240" width="240" align="middle"/></a></p>
<p>One possible eventual consistency property is <em>read-your-own-writes</em> consistency, meaning a process is guaranteed to see the writes it has made when it does reads.  This is a very useful property that makes programming easier. Note that neither of the above examples provide read-your-own-writes consistency.  Also worth considering with this model is the definition of “your”.  On a web application, that might be the user.  If the system’s load balancer sends requests to different app servers, having read-your-own-write consistency for a single app server might not solve the real world consistency need.</p>
<p><strong>EC Use Case Checklist</strong></p>
<p>Thus when using eventual consistency, it is good for the architect to ask:</p>
<ul>
<li>can my use case tolerate stale reads?</li>
<li>can it tolerate reading values out of order?  if not, is my configuration monotonic read consistent?</li>
<li>can it tolerate not reading my own writes?  if not, is my configuration read-your-own-write consistent?</li>
</ul>";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:38:"http://blog.mongodb.org/post/498145601";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:38:"http://blog.mongodb.org/post/498145601";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Mon, 05 Apr 2010 09:42:00 -0400";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:17;a:6:{s:4:"data";s:0:"";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:1:{s:0:"";a:5:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:36:"On Distributed Consistency -- Part 1";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:4556:"<p>See also:</p>
<ul>
<li><a href="http://blog.mongodb.org/post/498145601/on-distributed-consistency-part-2-some-eventual">Part  2 - Eventual Consistency</a></li>
<li><a href="http://blog.mongodb.org/post/505822180/on-distributed-consistency-part-3-network">Part 3 - Network Partitions</a></li>
<li><a href="http://blog.mongodb.org/post/516567520/on-distributed-consistency-part-4-multi-data-center">Part 4 - Multi Data Center</a></li>
<li><a href="http://blog.mongodb.org/post/520888030/on-distributed-consistency-part-5-many-writer">Part 5 - Multi Writer Eventual Consistency</a></li>
<li><a href="http://blog.mongodb.org/post/523516007/on-distributed-consistency-part-6-consistency-chart">Part 6 - Consistency Chart</a></li>
</ul>
<p>For distributed databases, consistency models are a topic of huge importance.  We’d like to delve a bit deeper on this topic with a series of articles, discussing subjects such as what model is right for a particular use case.  Please jump in and help us in the comments.</p>
<p>We’ll start here with a basic introduction to the subject.</p>
<p><strong>CAP</strong></p>
<p>The <a href="http://portal.acm.org/citation.cfm?id=564585.564601">CAP theorem</a> states that one can only have two of <span>c</span>onsistency, <span>a</span>vailability, and tolerance to network <span>p</span>artitions at the same time. In distributed systems, network partitioning is inevitable and must be tolerated, so essential CAP means that we cannot have both consistency and 100% availability. </p>
<p>Informally, I would summarize the CAP theorem as:</p>
<ul>
<li>If the network is broken, your database won’t work.</li>
</ul>
<p>However, we do get to pick the definition of “won’t work”.  It can either mean down (unavailable) or inconsistent (stale data).</p>
<p>More precisely what do we mean by “consistency”?  The academic work in this area is referring to “one copy serializability” or <a href="http://portal.acm.org/citation.cfm?id=78969.78972">“linearizability”</a>. If a series of operations or transactions are performed, they are applied in a consistent order. One less formal way of thinking about the trade-off is “Could I be reading and manipulating stale/dirty data? Can I always write?”</p>
<p><strong>Embodiments</strong></p>
<p>We have two classes of architectures: a C class (strongly consistent) and an A class (higher availability looser consistency).  Let’s consider some real-world distributed systems and where they are classified.</p>
<p><a href="http://citeseerx.ist.psu.edu/viewdoc/summary?doi=10.1.1.127.6956">Amazon Dynamo</a> is a distributed data store which implements <a href="http://weblogs.java.net/blog/2007/11/27/consistent-hashing">consistent hashing</a> and is in the A camp.  It provides eventual consistency.  One may read old data.</p>
<p>CouchDB is typically used with asynchronous master-master replication and is in the A camp.  It provides eventual consistency.</p>
<p>A MongoDB auto-sharding+replication cluster has a master server at a given point in time for each shard.  This is in the C camp.  Traditional RDBMS systems are also strongly consistent (as typically used) - a synchronous RDBMS cluster for example.</p>
<p>It’s worth noting that alternate configurations of these products sometimes alter their consistency (and performance) properties.  For our discussion here, we’ll assume these products are configured in their common case setup, unless otherwise specified.</p>
<p><strong>Write Availability, not Read Availability, is the Main Question</strong></p>
<p>With most databases today, it’s easy to have any number of asynchronous slave replicas distributed about the world.  If networks partition, we would then still have access to local slave data.  As the replication is asynchronous, this data is eventually consistent, so this result is not surprising — we are now in the A class of systems.  However, almost all designs, even from the C class, can add on asynchronous read capabilities easy.  Thus, the critical design decisions are around write availability.</p>
<p><strong>The Trade-offs<br/></strong></p>
<ul>
<li>even load distribution is easier in eventually consistent systems</li>
<li>multi-data center support is easier in eventually consistent systems</li>
<li>some problems are not solvable with eventually consistent systems</li>
<li>code is sometimes simpler to write in strongly consistent systems</li>
</ul>
<p>We will discuss these pros in cons in more details in subsequent articles.</p>
<p>—dwight</p>";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:38:"http://blog.mongodb.org/post/475279604";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:38:"http://blog.mongodb.org/post/475279604";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Fri, 26 Mar 2010 15:32:00 -0400";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:18;a:6:{s:4:"data";s:0:"";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:1:{s:0:"";a:5:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:32:"MongoDB 1.4 Ready for Production";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:3892:"<p>The MongoDB team is very excited to announce the release of MongoDB 1.4.0.  This is the culmination of 3 months of work in the 1.3 branch and has a large number of very important changes.</p>
<p>Many users have been running 1.3 in production, so this release is already very thoroghly vetted both by our regressions systems and by real users.</p>
<p>Some highlights:</p>
<p><strong>Core server enhancements</strong></p>
<ul>
<li>concurrency improvements</li>
<li>indexing memory improvements</li>
<li><a href="http://www.mongodb.org/display/DOCS/Indexes#Indexes-BackgroundIndexBuilding">background index creation</a></li>
<li>better detection of regular expressions so the index can be used in more cases</li>
<li><a title="performance numbers" href="http://blog.mongodb.org/post/472834501/mongodb-1-4-performance">performance numbers</a></li>
</ul>
<p><strong>Replication & Sharding</strong></p>
<ul>
<li>better handling for restarting slaves offline for a while</li>
<li>fast new slaves from snapshots</li>
<li>configurable slave delay</li>
<li>replication handles clock skew on master</li>
<li>
<a href="http://www.mongodb.org/display/DOCS/Updating#Updating-%2524inc">$inc</a> replication fixes</li>
<li>sharding alpha 3 - notably 2 phase commit on config servers</li>
</ul>
<p><strong>Deployment & production</strong></p>
<ul>
<li>configure “slow” for profiling</li>
<li>ability to do <a href="http://www.mongodb.org/display/DOCS/fsync+Command#fsyncCommand-Lock%252CSnapshotandUnlock">fsync + lock</a> for backing up raw files</li>
<li>option for separate directory per db</li>
<li>http://localhost:28017/_status to get serverStatus via http</li>
<li>REST interface is off by default for security (—rest to enable)</li>
<li>can rotate logs with a db command, logRotate</li>
<li>enhancements to serverStatus - counters/replication lag</li>
<li>new mongostat tool and db.serverStatus() enhancements</li>
</ul>
<p><strong>Query language improvements</strong></p>
<ul>
<li>
<a href="http://www.mongodb.org/display/DOCS/Advanced+Queries#AdvancedQueries-ConditionalOperator%253A%2524all">$all</a> with regex</li>
<li><a href="http://www.mongodb.org/display/DOCS/Advanced+Queries#AdvancedQueries-Metaoperator%253A%2524not">$not</a></li>
<li>partial matching of array elements <a href="http://www.mongodb.org/display/DOCS/Advanced+Queries#AdvancedQueries-ConditionalOperator%253A%2524elemMatch">$elemMatch</a>
</li>
<li>
<a href="http://www.mongodb.org/display/DOCS/Updating#Updating-The%2524positionaloperator">$</a> operator for updating arrays</li>
<li><a href="http://www.mongodb.org/display/DOCS/Updating#Updating-%2524addToSet">$addToSet</a></li>
<li><a href="http://www.mongodb.org/display/DOCS/Updating#Updating-%2524unset">$unset</a></li>
<li>
<a href="http://www.mongodb.org/display/DOCS/Updating#Updating-%2524pull">$pull</a> supports object matching</li>
<li>
<a href="http://www.mongodb.org/display/DOCS/Updating#Updating-%2524set">$set </a>with array indices</li>
</ul>
<p><strong>Geo</strong></p>
<ul>
<li><a href="http://www.mongodb.org/display/DOCS/Geospatial+Indexing">2d geospatial search</a></li>
<li>geo $center and $box searches</li>
</ul>
<p>Downloads: <a title="www.mongodb.org/display/DOCS/Downloads" href="http://www.mongodb.org/display/DOCS/Downloads"><a href="http://www.mongodb.org/display/DOCS/Downloads">www.mongodb.org/display/DOCS/Downloads</a></a></p>
<p>Full Change Log: <a href="http://jira.mongodb.org/secure/IssueNavigator.jspa?requestId=10080">jira</a></p>
<p>Release Notes: <a href="http://www.mongodb.org/display/DOCS/1.4+Release+Notes"><a href="http://www.mongodb.org/display/DOCS/1.4+Release+Notes">http://www.mongodb.org/display/DOCS/1.4+Release+Notes</a></a></p>
<p>Thanks for all your continued support, and we hope MongoDB 1.4 works great for you.</p>
<p>As always, please let us know of any issues,</p>
<p>-Eliot and the MongoDB Team</p>";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:38:"http://blog.mongodb.org/post/472835820";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:38:"http://blog.mongodb.org/post/472835820";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Thu, 25 Mar 2010 13:22:00 -0400";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:19;a:6:{s:4:"data";s:0:"";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:1:{s:0:"";a:5:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:23:"MongoDB 1.4 Performance";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:1889:"<p>We generally avoid posting benchmarks and suggest people create their own targeting their use cases. However, we have decided to publish a few of our internal micro-benchmarks comparing 1.2 with 1.4RC2 (aka 1.3.5) to show that in almost all cases performance is the same or better (sometime significantly so), even though we’ve added many new features.</p>
<p>The test works by spawning N threads and having them hammer the DB with one operation as fast as they can. It is probably best to ignore the raw numbers and only look at the relative performance. In particular, these numbers shouldn’t be compared against other databases. </p>
<p><a href="http://media.mongodb.org/MongoDBBenchmarks.jpg">Results</a></p>
<p><a href="http://github.com/mongodb/mongo-perf/blob/master/benchmark.cpp">Code for benchmarks</a></p>
<p>A few highlights (and one lowlight):</p>
<ul>
<li>Single threaded query performance increased slightly</li>
<li>Query performance increases linearly or super-linearly as more cores are used</li>
<li>Insert performance increases by 10-30% vs 1.2</li>
<li>It is usually faster to create an index after importing your data than before. More so in 1.4.</li>
<li>Not shown, but performance for both 1.2 and 1.4 held steady from 10 threads up to at least 500 threads. Even where it looks like the lines will cross, they do not.</li>
<li>Update and Upsert performance is the same or higher until using more than 4 hammering threads. In practice, this shouldn’t effect users unless they are already doing more updates per second than the server can handle. Even so, we will look into solutions to this in the 1.5.x series.</li>
</ul>
<p>This test was run on an Intel Core i7 Quad 860 2.8GHz with 8GB of RAM and an Intel G2 SSD. Even though they improved performance, HyperThreading and TurboBoost were disabled as they can skew results in nondeterministic ways.</p>";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:38:"http://blog.mongodb.org/post/472834501";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:38:"http://blog.mongodb.org/post/472834501";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Thu, 25 Mar 2010 13:21:42 -0400";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}}}}}}}}}}}}s:4:"type";i:128;s:7:"headers";a:19:{s:6:"server";s:21:"Apache/2.2.3 (CentOS)";s:3:"p3p";s:44:"CP=ALL ADM DEV PSAi COM OUR OTRo STP IND ONL";s:13:"x-tumblr-user";s:7:"mongodb";s:13:"last-modified";s:29:"Thu, 20 Jan 2011 19:15:24 GMT";s:12:"x-robots-tag";s:7:"noindex";s:13:"cache-control";s:11:"max-age=900";s:12:"x-cache-auto";s:3:"hit";s:4:"vary";s:15:"Accept-Encoding";s:16:"content-encoding";s:4:"gzip";s:13:"x-tumblr-usec";s:7:"D=88205";s:12:"content-type";s:23:"text/xml; charset=utf-8";s:14:"content-length";s:5:"24671";s:4:"date";s:29:"Sun, 30 Jan 2011 22:51:05 GMT";s:9:"x-varnish";s:21:"1805385815 1786640984";s:3:"age";s:4:"6453";s:7:"x-cache";s:26:"MISS from rack1.tumblr.com";s:14:"x-cache-lookup";s:29:"MISS from rack1.tumblr.com:80";s:3:"via";s:56:"1.1 varnish, 1.0 rack1.tumblr.com:80 (squid/2.6.STABLE6)";s:10:"connection";s:5:"close";}s:5:"build";s:14:"20110128231735";}