<?php
session_start();
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"

    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<html lang="en-US" xmlns="http://www.w3.org/1999/xhtml" dir="ltr">

<head>

	<title>BuzzBlaze</title>

	<meta http-equiv="Content-type" content="text/html; charset=utf-8" />

	<link rel="shortcut icon" href="css/images/favicon.ico" />

	<link rel="stylesheet" href="css/style.css" type="text/css" media="all" />

	<link rel="stylesheet" href="fancybox/jquery.fancybox-1.3.4.css" type="text/css" media="all" />

	<!--[if IE 6]>

		<link rel="stylesheet" href="css/ie6.css" type="text/css" media="all" />

	<![endif]-->

</head>

<body>

	<div id="wrap">

		

	    <div id="header">

	        <div class="shell">

	            <h1 id="logo-big" class="left"><a href="#">BuzzBlaze</a></h1>
				
				<div id="login">

					<a href="#" class="btn">

						<strong>LOGIN</strong>

						<small>returning users</small>

					</a>

					<div class="login-dd">

						<div class="shadow">

							<div class="inner">

								<p>Login to your BuzzBlaze Dashboard</p>

								<div class="login-form">

									<form action="" method="post">

										<div><label>Username</label></div>

										<div><input type="text" class="field" value="" title="" /></div>

										<div><label>Password</label></div>

										<div><input type="password" class="field" value="" title="" /></div>

										<div class="details">

											<label class="left"><input type="checkbox" class="checkbox" value="" title="" /> Remember Me</label>

											<a href="#" class="right">Forgot password?</a>

										</div>

										<div>

											<input type="submit" class="submit right notext" value="LOGIN" title="LOGIN" />

											<div class="cl">&nbsp;</div>

										</div>

									</form>

								</div>

							</div>

						</div>

					</div>

				</div>

	            <div class="cl">&nbsp;</div>

	        </div>

	    </div>

	    

	    <div id="main">

	        <div class="shell">

        		<div id="sign-up-box" class="modal-box">

        			<div class="head">

        				Sign Up for BuzzBlaze 

        			</div>

        			<div class="body">

        				<div class="gform_wrapper">

        					<form id="sign_up">

	        					<ul class="gform_fields">

	        						<li class="gfield">

	        							<label class="gfield_label gfield_label_medium">Full name</label>

	        							<div class="ginput_container">

	        								<input type="text" name="fname" class="medium left field-fullname" value="" title="Enter your first and last name" />

	        								<p class="control-bar left">

	        									Enter your first and last name

	        								</p>

	        								<div class="cl">&nbsp;</div>

	        								<small>Your full name will appear on your public profile</small>

	        							</div>

	        							<div class="cl">&nbsp;</div>

	        						</li>

	        						<li class="gfield">

	        							<label class="gfield_label gfield_label_medium">Username</label>

	        							<div class="ginput_container">

	        								<input type="text" name="uname" id="field-username" class="medium left field-username" value="" title="Pick a unique username" />

	        								<p class="control-bar left">

	        									Pick a unique username

	        								</p>

	        								<div class="cl">&nbsp;</div>

	        								<small>Your public profile is <span id="user-address">http://buzzblaze.com/<span >username</span></span></small>

	        							</div>

	        							<div class="cl">&nbsp;</div>

	        						</li>  

	        						<li class="gfield">

	        							<label class="gfield_label gfield_label_medium">Email</label>

	        							<div class="ginput_container">

	        								<input type="text" name="email" class="medium left field-email" value="" title="Enter your real email address" />

	        								<p class="control-bar left">

	        									Enter your real email address

	        								</p>

	        								<div class="cl">&nbsp;</div>

	        								<small>Email will not be publicly shared</small>

	        							</div>

	        							<div class="cl">&nbsp;</div>

	        						</li>  

	        						<li class="gfield">

	        							<label class="gfield_label gfield_label_medium">New Password</label>

	        							<div class="ginput_container">

	        								<input type="password" name="pass" class="medium left field-password" value="" title="6 characters or more (no spaces)" />

	        								<p class="control-bar left">

	        									6 characters or more (no spaces)

	        								</p>

	        								<div class="cl">&nbsp;</div>

	        							</div>

	        							<div class="cl">&nbsp;</div>

	        						</li>        						      						      						

	        						<li class="gfield">

	        							<label class="gfield_label gfield_label_medium">Confirm Password</label>

	        							<div class="ginput_container">

	        								<input type="password" name="cpass" class="medium left field-confirm-password" value="" title="Re-type your password" />

	        								<p class="control-bar left">

	        									

	        								</p>

	        								<div class="cl">&nbsp;</div>

	        							</div>

	        							<div class="cl">&nbsp;</div>

	        						</li>

	        						<li class="gfield">

	        							<p style="width: 375px; line-height: 1; padding: 0 0 0 135px;"><small>By clicking on "Sign Up" below, you are confirming that you accept the <a href="#">Terms of Use</a> and <a href="#">Privacy Policy</a> for using BuzzBlaze.</small></p>

	        						</li>

	        					</ul>

	        					

	        					<div class="gform_footer">

	        						<input type="submit" class="btn-signup" value="Sign Up" title="Sign Up"/>

	        						<!-- <a title="Login" class="btn-signup">Sign Up</a> -->

	        					</div>

	        				</form>

        				</div>

        			</div>

        		</div>

        		<p class="tc blue">Don't have an account? <a href="#">Sign up here!</a></p>

    	    </div>

	    </div>

	    

	    <!-- Sticky footer -->

	    <div id="footer-push"></div>

	    <!-- END Sticky footer -->

	</div>

	

	<!-- Footer -->

	<div id="footer">

	    <div class="shell">

	        <p>

	            <span class="foot-nav right">

	                <a href="#">About</a> &middot; 

	                <a href="#">Advertising</a> &middot; 

	                <a href="#">Developers</a> &middot; 

	                <a href="#">Careers</a> &middot; 

	                <a href="#">Privacy</a> &middot; 

	                <a href="#">Terms</a> &middot; 

	                <a href="#">Help</a>

	            </span>

	            

	            BuzzBlaze &copy; 2010 &middot; <a href="#">English (US)</a>

	        </p>

	        <div class="cl">&nbsp;</div>

	    </div>

	</div>

	<!-- END Footer -->

	<script type="text/javascript" src="js/jquery-1.4.4.min.js"></script>

	<script src="js/jquery-ui-personalized-1.6rc2.min.js" type="text/javascript" charset="utf-8"></script>

	<script src="js/panels.js" type="text/javascript" charset="utf-8"></script>

	<script src="js/jquery.jcarousel.min.js" type="text/javascript" charset="utf-8"></script>

	<script src="js/jquery.vticker-min.js" type="text/javascript" charset="utf-8"></script>

	<script src="js/jquery.easing.1.3.js" type="text/javascript" charset="utf-8"></script>

	<script src="fancybox/jquery.fancybox-1.3.4.pack.js" type="text/javascript" charset="utf-8"></script>

	<script src="fancybox/jquery.mousewheel-3.0.4.pack.js" type="text/javascript" charset="utf-8"></script>

	<script src="js/func.js" type="text/javascript" charset="utf-8"></script>

	<script type="text/javascript">

        Panels.init();

	</script>

</body>

</html>