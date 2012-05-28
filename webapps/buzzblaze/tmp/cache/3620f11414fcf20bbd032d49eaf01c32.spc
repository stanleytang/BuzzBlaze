a:4:{s:5:"child";a:1:{s:0:"";a:1:{s:3:"rss";a:1:{i:0;a:6:{s:4:"data";s:2:"

";s:7:"attribs";a:1:{s:0:"";a:1:{s:7:"version";s:3:"2.0";}}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:1:{s:0:"";a:1:{s:7:"channel";a:1:{i:0;a:6:{s:4:"data";s:93:"
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  ";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:1:{s:0:"";a:9:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:23:"Coding the Architecture";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:37:"http://www.codingthearchitecture.com/";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:36:"Software architecture for developers";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:8:"language";a:1:{i:0;a:5:{s:4:"data";s:2:"en";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:9:"copyright";a:1:{i:0;a:5:{s:4:"data";s:23:"Coding the Architecture";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:13:"lastBuildDate";a:1:{i:0;a:5:{s:4:"data";s:29:"Mon, 21 Feb 2011 12:13:30 GMT";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:9:"generator";a:1:{i:0;a:5:{s:4:"data";s:38:"Pebble (http://pebble.sourceforge.net)";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"docs";a:1:{i:0;a:5:{s:4:"data";s:31:"http://backend.userland.com/rss";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"item";a:10:{i:0;a:6:{s:4:"data";s:78:"
    
    
    
      
        
      
      
    
    
    
    
    
    
  ";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:1:{s:0:"";a:6:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:14:"I need a price";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:67:"http://www.codingthearchitecture.com/2011/02/21/i_need_a_price.html";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:5197:"
          <p>
We all know the problems associated with fixed price, fixed scope contracts for software projects. Yes, there are <a href="http://www.infoq.com/articles/agile-contracts" target="_blank">alternative ways to run a software project</a>, but sometimes you just need to quote a single price. Perhaps you need to secure internal budget or maybe you're a consulting company bidding for work. Either way, getting the cost wrong can have some huge consequences for everybody involved. Let's imagine that you *do* need to provide an estimate of the effort required to deliver some software. Sounds technical, let's ask the developers.
</p>

<p>
More often than not, asking software developers to produce estimates as the basis of a fixed price, fixed scope contract is a really bad idea. You see, we software developers tend to have a very technology-centric view of the world. We spend most of our days staring at code in our IDEs and we like to talk about things like classes and dependency injection and refactoring and automated testing and a whole bunch of other deeply technical stuff. There's nothing wrong this, and if you're not thinking about these sorts of things then you're probably in the wrong job.
</p>

<h3>Step back to see the bigger picture</h3>
<p>
The problem with software developers costing up software projects comes from not leaving that world behind and <a href="http://www.codingthearchitecture.com/pages/book/what-is-the-big-picture.html" target="_blank">stepping back to see the bigger picture</a>. If you're trying to cost up a project while having discussions about the number of fields on a user interface or whether the data should be stored as XML or broken out into a full relational model then you're going about the estimation process in the wrong way.
</p>

<p>
Sure, these things do become important at some point in time, but they probably don't make a great deal of difference in the grand scheme of things. What does? It's the major <a href="http://www.codingthearchitecture.com/pages/book/understand-the-architectural-drivers.html" target="_blank">architectural drivers</a> ... the functional requirements, the non-functional requirements, the constraints and the principles. Instead of thinking about the details, you need to be asking questions like...
</p>

<ul>
<li>What are the major drivers for the software? What problems is it solving? If it's replacing an existing software system, what's wrong with the old one? What are the benefits delivered by the software?</li>
<li>Are there any <a href="http://www.codingthearchitecture.com/pages/book/interfaces.html" target="_blank">inter-system interfaces</a>? What are they? Who owns them?</li>
<li>Are there non-functional requirements (e.g. security, audit) or constraints (e.g. regulatory) that will prevent the system from going live?</li>
<li>What technologies are already in use and what technology choices do we realistically have given the environment?</li>
<li>Who will be operating, supporting and maintaining the system in the future? What sort of skills do they have?</li>
<li>etc</li>
</ul>

<p>
These sorts of questions will help you comprehend the size and scale of the software project much more than understanding how many columns you need to store the data.
</p>

<h3>Most requirements documents are inadequate for estimation</h3>
<p>
Most of my career has been spent in a consulting environment and I've seen my fair share of requirements specifications over the years. Without doubt, I can say that none of them have been good enough to produce an estimate from. Look at it from the other side of the coin. Imagine you have a vision for a software project that you've been living and breathing for a few months. You think about it, you talk about it and you visualise it with colleagues. Then, in order to engage a development team, you open up Microsoft Word and start typing up a requirements document. The thing is, the reader probably doesn't have the same amount of context that you do. Those one-liners you've used to describe the major features are likely to seem ambiguous to people that haven't lived and breathed the vision like you have. <a href="http://agilemanifesto.org">Customer collaboration over contract negotiation</a> anyone?
</p>

<p>
Put simply, it's unrealistic to expect somebody to produce a cost estimate from a few pages of "requirements", particularly since that document normally doesn't include all of the other essential information about the environmental constraints, policies, technologies, etc. If you find yourself in the position of having to provide a <a href="http://www.codingthearchitecture.com/pages/book/ballpark-estimates.html" target="_blank">ballpark estimate</a>, especially if it's going to be used as the basis for a fixed price contract, the best piece of advice I can give you is to collaborate. Grab a room with a whiteboard, invite some of the key stakeholders and use this as a forum to <a href="http://www.codingthearchitecture.com/pages/book/ballpark-estimates.html" target="_blank">understand the vision</a>. Oh, and don't forget to get those risks, issues, assumptions and dependencies out into the open.
</p>
        ";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:8:"comments";a:1:{i:0;a:5:{s:4:"data";s:76:"http://www.codingthearchitecture.com/2011/02/21/i_need_a_price.html#comments";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:67:"http://www.codingthearchitecture.com/2011/02/21/i_need_a_price.html";s:7:"attribs";a:1:{s:0:"";a:1:{s:11:"isPermaLink";s:4:"true";}}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:29:"Mon, 21 Feb 2011 12:13:30 GMT";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:1;a:6:{s:4:"data";s:78:"
    
    
    
      
        
      
      
    
    
    
    
    
    
  ";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:1:{s:0:"";a:6:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:46:"Where are the software architects of tomorrow?";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:98:"http://www.codingthearchitecture.com/2011/02/17/where_are_the_software_architects_of_tomorrow.html";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:814:"
          <p>
Agile and software craftsmanship are two great examples of how we're striving to improve and push the software industry forward. We spend a lot of time talking about writing code, testing, tools, technologies and the all of the associated processes. And that makes a lot of sense. Let's not forget that the end-goal here is delivering benefit to people through software, and <i>working software</i> is key.
</p>

<p>
But we shouldn't forget that there are some other aspects of the software development process that few people genuinely have experience with. Think about how <i>you</i> would answer the following questions.
</p>

<p>
<a href="http://www.codingthearchitecture.com/pages/book/where-are-the-software-architects-of-tomorrow.html" target="_blank">Read the full essay...</a>
</p>
        ";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:8:"comments";a:1:{i:0;a:5:{s:4:"data";s:107:"http://www.codingthearchitecture.com/2011/02/17/where_are_the_software_architects_of_tomorrow.html#comments";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:98:"http://www.codingthearchitecture.com/2011/02/17/where_are_the_software_architects_of_tomorrow.html";s:7:"attribs";a:1:{s:0:"";a:1:{s:11:"isPermaLink";s:4:"true";}}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:29:"Thu, 17 Feb 2011 07:39:37 GMT";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:2;a:6:{s:4:"data";s:78:"
    
    
    
      
        
      
      
    
    
    
    
    
    
  ";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:1:{s:0:"";a:6:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:20:"Collaborative design";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:73:"http://www.codingthearchitecture.com/2011/02/15/collaborative_design.html";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:1006:"
          <p>
Let's imagine that you've been tasked with building a 3-tier web application and you have a small team that includes people with specialisms in web technology, server-side programming and databases. From a resourcing point of view this is excellent because, together, you have experience across the entire stack. You shouldn't have any problems, right? 
</p>

<p>
The effectiveness of the overall team comes down to a number of factors that include people's willingness to leave their egos at the door and focus on delivering the best solution given the context. Sometimes, though, individual specialisms can work against a team; simply through a lack of team-based experience or because ego gets in the way of the common goal. Ask the specialists in the team where a certain feature or component should go and you might get 3 totally different answers...
</p>

<p>
<a href="http://www.codingthearchitecture.com/pages/book/collaborative-design.html">Read the full essay...</a>
</p>

        ";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:8:"comments";a:1:{i:0;a:5:{s:4:"data";s:82:"http://www.codingthearchitecture.com/2011/02/15/collaborative_design.html#comments";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:73:"http://www.codingthearchitecture.com/2011/02/15/collaborative_design.html";s:7:"attribs";a:1:{s:0:"";a:1:{s:11:"isPermaLink";s:4:"true";}}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:29:"Tue, 15 Feb 2011 10:34:15 GMT";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:3;a:6:{s:4:"data";s:78:"
    
    
    
      
        
      
      
    
    
    
    
    
    
  ";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:1:{s:0:"";a:6:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:27:"Tutorial @ QCon London 2011";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:78:"http://www.codingthearchitecture.com/2011/02/14/tutorial_qcon_london_2011.html";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:2673:"
          <p>
I'm running a tutorial at the upcoming QCon London conference entitled <a href="http://qconlondon.com/london-2011/presentation/Designing+software%2C+drawing+pictures" target="_blank">Designing software, drawing pictures</a>. In essence, it's about the process of designing software if all you have is a blank sheet of paper and a set of vague requirements. Much of what we write about on this website is about software architecture ... defining structure, putting sufficient foundations in place, laying out the vision for a software system and then carrying that through the project to a successful conclusion. It's really just another angle to <a href="http://www.codingthearchitecture.com/2011/01/19/software_craftsmanship_i_want_it_all.html" target="_blank">software craftsmanship</a> and I firmly believe that software architecture needs to be done on most software projects, but of course it doesn't have to be about "big design up front". Even the most agile of projects can benefit from the introduction of the consistency and clarity that lightweight software architecture brings.
</p>

<h3>Why?</h3>
<p>
So why the tutorial? Well, it's a 1-day version of our <a href="http://www.softwarearchitecturefordevelopers.com" target="_blank">Software Architecture for Developers training course</a> where you'll be asked to design some software, choose some technologies and draw some diagrams to illustrate your design. Most people I've worked with, trained and coached don't tend to design a software system from scratch all that frequently (if at all) and it therefore follows that this is the area where most people lack experience. This tutorial is about providing developers with the opportunity to design something from scratch while receiving guidance about how to simplify the design and how to illustrate that design using a collection of simple pictures. After all, if we're losing our technical mentors to non-technical management positions, how do <a href="http://www.codingthearchitecture.com/pages/book/where-are-the-software-architects-of-tomorrow.html" target="_blank">the software architects of tomorrow</a> gain experience in this area?
</p>

<p align="center">
<img src="http://www.codingthearchitecture.com/images/qcon2011-designing-software-drawing-pictures-handouts.png" alt="QCon 2011 handouts" />
</p>

<p>
You can find more details of the tutorial on the <a href="http://qconlondon.com/london-2011/presentation/Designing+software%2C+drawing+pictures" target="_blank">QCon London 2011 website</a>. Join us if you want to know how to go about the software design process in a lightweight, structured and pragmatic way.
</p>
        ";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:8:"comments";a:1:{i:0;a:5:{s:4:"data";s:87:"http://www.codingthearchitecture.com/2011/02/14/tutorial_qcon_london_2011.html#comments";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:78:"http://www.codingthearchitecture.com/2011/02/14/tutorial_qcon_london_2011.html";s:7:"attribs";a:1:{s:0:"";a:1:{s:11:"isPermaLink";s:4:"true";}}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:29:"Mon, 14 Feb 2011 09:43:16 GMT";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:4;a:6:{s:4:"data";s:78:"
    
    
    
      
        
      
      
    
    
    
    
    
    
  ";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:1:{s:0:"";a:6:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:24:"Just enough architecture";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:77:"http://www.codingthearchitecture.com/2011/02/03/just_enough_architecture.html";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:874:"
          <p>
One of the major points of disagreement about software relates to how much up front design to do. People are very polarised as to <i>when</i> they should do design and <i>how much</i> they should do. From experience of working with software teams, the views basically break down like this.
</p>

<ul>
<li>We need to do all of the software architecture up front, before we start coding features.</li>
<li>Software architecture doesn't need to be done up front; we'll evolve it as we progress.</li>
<li>Meh, we don't need to do software architecture, we have an excellent team.</li>
</ul>

<p>
These different views do raise an interesting question, how much architecture do you <i>need</i> to do up front?
</p>

<p>
<a href="http://www.codingthearchitecture.com/pages/book/just-enough-architecture.html" target="_blank">Read the full essay...</a>
</p>
        ";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:8:"comments";a:1:{i:0;a:5:{s:4:"data";s:86:"http://www.codingthearchitecture.com/2011/02/03/just_enough_architecture.html#comments";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:77:"http://www.codingthearchitecture.com/2011/02/03/just_enough_architecture.html";s:7:"attribs";a:1:{s:0:"";a:1:{s:11:"isPermaLink";s:4:"true";}}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:29:"Thu, 03 Feb 2011 23:00:00 GMT";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:5;a:6:{s:4:"data";s:78:"
    
    
    
      
        
      
      
    
    
    
    
    
    
  ";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:1:{s:0:"";a:6:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:20:"Software Project SOS";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:73:"http://www.codingthearchitecture.com/2011/01/29/software_project_sos.html";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:3834:"
          <p>
I ran my "Software Project SOS" session at Skills Matter on Thursday evening and it was brilliant fun. The premise behind the session was to present the current state of a struggling software project and understand what could be done to fix it.
</p>

<p align="center">
<img src="http://www.codingthearchitecture.com/presentations/skillsmatter2011-software-project-sos/slides/slide.003.jpg" alt="Setting the scene" width="400px" />
</p>

<p>
To set the scene, rather than describe the software project myself I asked everybody to imagine they were taking over a project that they had no exposure to. In order to understand what state the project was in, they had to ask me questions to explore the situation and discover the important information (an important consulting skill).
</p>

<p>
With the facts discovered (the white index cards in the photos below), I then asked everybody to vote on those they thought were the most important to do something about in order to bring the software project back on track.
</p>

<p align="center">
<img src="http://www.codingthearchitecture.com/presentations/skillsmatter2011-software-project-sos/slides/slide.005.jpg" width="400px" alt="Most votes" />
<img src="http://www.codingthearchitecture.com/presentations/skillsmatter2011-software-project-sos/slides/slide.006.jpg" width="400px" alt="Few votes" />
<img src="http://www.codingthearchitecture.com/presentations/skillsmatter2011-software-project-sos/slides/slide.007.jpg" width="400px" alt="No votes" />
</p>

<p>
The voting certainly picked out the big-ticket items that needed fixing in this particular scenario and it was amazing to see this unfolding. No helping, no prompting; everybody just jumped on these items.
</p>

<p>
For the final part of the session, I asked people to pair up, take a couple of the cards and jot down some ideas of the changes they could make to turn the project around.
</p>

<p align="center">
<img src="http://www.codingthearchitecture.com/presentations/skillsmatter2011-software-project-sos/slides/slide.004.jpg" width="400px" alt="Summary" />
</p>

<p>
The room was buzzing for about 5-10 minutes while everybody was throwing ideas around and busily writing up those ideas on post-it notes. The end-result is what you see above and the full set of photos showing all of the suggested changes is available to <a href="http://bit.ly/h9dmjO">view online</a>.
</p>

<p>
Take a look at the photos for yourself. They're mighty impressive when you consider that very few of these people had met before and they came from different backgrounds, with different levels of experience working on different types of software. Yet, as a group, they identified the key problems that were causing the project to struggle and came up with a number of ways in which they could be resolved.
</p>

<p>
The other thing that I really admired was the level of pragmatism exhibited. There's an awful lot of evangelism being thrown around the IT industry at the moment, particularly with the buzz around lean, agile and <a href="http://www.codingthearchitecture.com/2011/01/19/software_craftsmanship_i_want_it_all.html" target="_blank">software craftsmanship</a>. Clearly many of these ideas are appropriate for turning this software project around, but nobody was stood up chanting that "agile is the one true way to build software", for example. The scenario we used was based upon a combination of real software projects and included a fair share of real-world constraints that couldn't be overlooked. They had to be taken into account and this is why the results of the session are so impressive - everything suggested was relevant, applicable and pragmatic.
</p>

<p>
Thanks again to everybody that came along and made it such an excellent evening ... I'm certainly looking to run this again.
</p>
        ";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:8:"comments";a:1:{i:0;a:5:{s:4:"data";s:82:"http://www.codingthearchitecture.com/2011/01/29/software_project_sos.html#comments";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:73:"http://www.codingthearchitecture.com/2011/01/29/software_project_sos.html";s:7:"attribs";a:1:{s:0:"";a:1:{s:11:"isPermaLink";s:4:"true";}}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:29:"Sat, 29 Jan 2011 15:02:00 GMT";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:6;a:6:{s:4:"data";s:78:"
    
    
    
      
        
      
      
    
    
    
    
    
    
  ";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:1:{s:0:"";a:6:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:51:"Software architecture training in London - Feb 2011";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:102:"http://www.codingthearchitecture.com/2011/01/20/software_architecture_training_in_london_feb_2011.html";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:1285:"
          <p>
The next public scheduled <a href="http://www.softwarearchitecturefordevelopers.com" target="_blank">Software Architecture for Developers</a> training course takes place at Skills Matter in London on the 7th/8th of February. 
</p>

<p>
The course is aimed at software developers that want to understand more about pragmatic software architecture and particularly recommended for those that have recently moved or about to move into technical lead type roles. It's also for anybody that believes <a href="http://www.codingthearchitecture.com/2011/01/19/software_craftsmanship_i_want_it_all.html" target="_blank">software craftsmanship</a> is important. ;-) There's an updated <a href="http://bit.ly/bCIvPG" target="_blank">preview of the content</a> if you want to see the sort of stuff we'll be covering and some <a href="http://www.softwarearchitecturefordevelopers.com/testimonials.html" target="_blank">testimonials</a> from people that have been on the course.
</p>

<p>
p.s. I'm also in London next week and I'll be presenting an "In the brain" session at Skills Matter called <a href="http://www.codingthearchitecture.com/2011/01/17/software_project_sos.html" target="_blank">Software Project SOS</a>. Feel free to get in touch if you want to meetup.
</p>
        ";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:8:"comments";a:1:{i:0;a:5:{s:4:"data";s:111:"http://www.codingthearchitecture.com/2011/01/20/software_architecture_training_in_london_feb_2011.html#comments";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:102:"http://www.codingthearchitecture.com/2011/01/20/software_architecture_training_in_london_feb_2011.html";s:7:"attribs";a:1:{s:0:"";a:1:{s:11:"isPermaLink";s:4:"true";}}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:29:"Thu, 20 Jan 2011 21:23:00 GMT";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:7;a:6:{s:4:"data";s:78:"
    
    
    
      
        
      
      
    
    
    
    
    
    
  ";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:1:{s:0:"";a:6:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:40:"Software craftsmanship ... I want it all";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:89:"http://www.codingthearchitecture.com/2011/01/19/software_craftsmanship_i_want_it_all.html";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:4473:"
          <p>
I did a talk today for the local BCS about how to get started if you need to design a software solution when all you have is a business vision and a blank sheet of paper. During the Q&A towards the end of the session, somebody asked whether the 80-20 rule was still holding true. In this particular case, the question was about whether software was developed in 20% of the time, with the remaining 80% being needed to make it actually work. Reading between the lines, in my head, I translated this as "does software development still suffer from the same old quality problems?".
</p>

<p>
My response was that some software teams do work this way and I'll stick by that. I've seen teams essentially <a href="http://cleancoder.posterous.com/software-craftsmanship-things-wars-commandmen" target="_blank">writing crap</a> and then relying on excessively long testing phases or large post-development maintenance contracts to patch all of the holes that shouldn't really be there in the first place. Other teams, however, put emphasis into actually getting it right first time using a lot of the "good" practices that you'd associate with modern software development; automated testing, continuous integration, source code control, patterns, reuse, etc. I'd also suggest that such teams can probably get it right way quicker than those other teams churning out whatever it is they do churn out.
</p>

<p>
If you've been following the software development blogosphere recently, you'll have seen a ton of stuff about <a href="http://parlezuml.com/blog/?postid=989" target="_blank">software craftsmanship</a>. The question I was asked is a perfect example of how doing a good job differs from doing a bad job. Craftsmanship if you like.
</p>

<p>
Now, there have been lots of posts recently about what software craftsmanship is or isn't; including discussion about what characterises a craftsman, whether it's just about beautiful code, whether it's about delivering what's expected and so on. For me, it's simple. I want it all and I want it now ... software that exhibits good design, is of a high quality, has beautiful code, works, meets expectations and generally makes everybody engaged in the process happy. I also want it to be done efficiently, effectively and with minimum messing around.
</p>

<p>
Our industry is a bit of a mixed bag. Some developers are excellent, always striving to improve, while others are just in it for the money. However you look at it, this software craftsmanship stuff is mainly about improvement from within. I <a href="http://www.codingthearchitecture.com/pages/training.html" target="_blank">train developers on a regular basis</a> and I'm trying to do my bit to help teams build better software. But what we really need is for people outside of the industry to start peeking in and see what's going on. I know it would be hard to achieve, but I do think that there should be some way for people using our services to differentiate the good from the bad. Many vendor-based certifications are essentially worthless and they certainly don't reflect anything about the craftsmanship aspects that people are talking about. A Microsoft certification might reflect that somebody knows what an ASP.NET page is, but could the holder of that certification actually design, build and deploy a robust, decent quality website that did what it was supposed to?
</p>

<p>
Many people engaging software development services have very low expectations of software teams, probably due to past failures or because they've hired 9-5 developers that were paid too much, didn't know what they're doing<sup>1</sup> and delivered nothing<sup>2</sup>. Others are simply naive about the whole engagement process and are being taken for a ride by organisations taking advantage of this fact. As an industry, I think it's time for some differentiation and professionalism across the board.
</p>

<p>
<sup>1</sup> Are <a href="http://www.itcontractor.com/Articles_IR35_News_Advice/view_article.asp?id_no=6157&photopage=0" target="_blank">half of IT professionals useless</a>?
</p>

<p>
<sup>2</sup> A friend told me a story about a contractor that was tasked with building a database-driven website and he basically only delivered a HTML mockup. He would always drive the keyboard during demos and nobody ever doubted his progress. But one day he was rumbled, left in a hurry and was never seen again. Beware the developer with no shoes.
</p>
        ";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:8:"comments";a:1:{i:0;a:5:{s:4:"data";s:98:"http://www.codingthearchitecture.com/2011/01/19/software_craftsmanship_i_want_it_all.html#comments";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:89:"http://www.codingthearchitecture.com/2011/01/19/software_craftsmanship_i_want_it_all.html";s:7:"attribs";a:1:{s:0:"";a:1:{s:11:"isPermaLink";s:4:"true";}}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:29:"Wed, 19 Jan 2011 21:30:38 GMT";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:8;a:6:{s:4:"data";s:78:"
    
    
    
      
        
      
      
    
    
    
    
    
    
  ";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:1:{s:0:"";a:6:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:20:"Software project SOS";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:73:"http://www.codingthearchitecture.com/2011/01/17/software_project_sos.html";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:1298:"
          <p>
A short note to say that I'm running an "In the brain" session in London at Skills Matter on the 27th January. This session is going to be very discussion driven, where we'll try to figure out what to do if you need to get your software project back on track.
</p>

<blockquote>
<h3>Software project SOS</h3>
<p>
If you believe what you read everywhere, all software teams are writing their applications using the latest technology with a comprehensive set of automated tests on their highly productive agile projects. Unfortunately the reality for some of us is far from this, with our projects suffering from a range of problems. In this session, we'll be looking at one or more software projects that are having issues and explore how to resolve them in an effective yet pragmatic way. Please get in touch by e-mailing simon.brown@codingthearchitecture.com if you want to see your own (anonymised) project featured in this session. This is your opportunity to get some free consultancy or to get a glimpse of how other software teams approach their projects.
</p>
</blockquote>

<p>
The fun starts at 6:30pm and you can find more information on the <a href="http://skillsmatter.com/event/agile-testing/software-project-sos" target="_blank">Skills Matter website</a>.
</p>
        ";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:8:"comments";a:1:{i:0;a:5:{s:4:"data";s:82:"http://www.codingthearchitecture.com/2011/01/17/software_project_sos.html#comments";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:73:"http://www.codingthearchitecture.com/2011/01/17/software_project_sos.html";s:7:"attribs";a:1:{s:0:"";a:1:{s:11:"isPermaLink";s:4:"true";}}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:29:"Mon, 17 Jan 2011 18:21:26 GMT";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:9;a:6:{s:4:"data";s:78:"
    
    
    
      
      
        
      
    
    
    
    
    
    
  ";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:1:{s:0:"";a:6:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:23:"Planning the year ahead";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:76:"http://www.codingthearchitecture.com/2011/01/11/planning_the_year_ahead.html";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:349:"
          <p>
Happy new year to everybody and thanks to all of you that I've worked with during the past year. 2011 is shaping up to be an exciting year and I just wanted to summarise some of the things that we have planned.
</p><p><a href="http://www.codingthearchitecture.com/2011/01/11/planning_the_year_ahead.html">Read more...</a></p>
        ";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:8:"comments";a:1:{i:0;a:5:{s:4:"data";s:85:"http://www.codingthearchitecture.com/2011/01/11/planning_the_year_ahead.html#comments";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:76:"http://www.codingthearchitecture.com/2011/01/11/planning_the_year_ahead.html";s:7:"attribs";a:1:{s:0:"";a:1:{s:11:"isPermaLink";s:4:"true";}}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:29:"Tue, 11 Jan 2011 22:26:13 GMT";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}}}}}}}}}}}}s:4:"type";i:128;s:7:"headers";a:6:{s:6:"server";s:17:"Apache-Coyote/1.1";s:13:"last-modified";s:29:"Mon, 21 Feb 2011 12:13:30 GMT";s:4:"etag";s:29:"Mon, 21 Feb 2011 12:13:30 GMT";s:12:"content-type";s:29:"application/xml;charset=UTF-8";s:17:"transfer-encoding";s:7:"chunked";s:4:"date";s:29:"Tue, 22 Feb 2011 00:31:45 GMT";}s:5:"build";s:14:"20110128231735";}