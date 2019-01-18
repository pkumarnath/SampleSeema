<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="2.0" xmlns:lxslt="http://xml.apache.org/xslt" 
	xmlns:math="http://exslt.org/math"
	xmlns:redirect="http://xml.apache.org/xalan/redirect"
	xmlns:stringutils="xalan://org.apache.tools.ant.util.StringUtils"
	extension-element-prefixes="redirect">
	<xsl:output method="html" indent="yes" encoding="UTF-8" />
	<xsl:decimal-format decimal-separator="."
		grouping-separator="," />
	<!-- Licensed to the Apache Software Foundation (ASF) under one or more 
		contributor license agreements. See the NOTICE file distributed with this 
		work for additional information regarding copyright ownership. The ASF licenses 
		this file to You under the Apache License, Version 2.0 (the "License"); you 
		may not use this file except in compliance with the License. You may obtain 
		a copy of the License at http://www.apache.org/licenses/LICENSE-2.0 Unless 
		required by applicable law or agreed to in writing, software distributed 
		under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES 
		OR CONDITIONS OF ANY KIND, either express or implied. See the License for 
		the specific language governing permissions and limitations under the License. -->

	<!-- Sample stylesheet to be used with Ant JUnitReport output. It creates 
		a set of HTML files a la javadoc where you can browse easily through all 
		packages and classes. -->
	<xsl:param name="output.dir" select="'.'" />
 	<xsl:param name="TITLE">
		Automation Test Result
	</xsl:param>
	<xsl:param name="URL"/>
	<xsl:param name="BrowserName"/>
	<xsl:param name="ExecutedOn"/>
	<xsl:param name="Product_Logo"/>
	


	<xsl:template match="testsuites">
		<!-- create the index.html -->
		<redirect:write file="{$output.dir}/SonnetTest.html">
			<xsl:call-template name="index.html" />
		</redirect:write>

		<!-- create the stylesheet.css -->
		<redirect:write file="{$output.dir}/archive/stylesheet.css">
			<xsl:call-template name="stylesheet.css" />
		</redirect:write>

		<!-- create the overview-packages.html at the root -->
		<redirect:write file="{$output.dir}/archive/overview-summary.html">
			<xsl:apply-templates select="." mode="overview.packages" />
		</redirect:write>

		<!-- create the all-packages.html at the root -->
		<redirect:write file="{$output.dir}/archive/overview-frame.html">
			<xsl:apply-templates select="." mode="all.packages" />
		</redirect:write>

		<!-- create the all-classes.html at the root -->
		<redirect:write file="{$output.dir}/archive/allclasses-frame.html">
			<xsl:apply-templates select="." mode="all.classes" />
		</redirect:write>

		<!-- create the all-tests.html at the root -->
		<redirect:write file="{$output.dir}/archive/all-tests.html">
			<xsl:apply-templates select="." mode="all.tests" />
		</redirect:write>

		<!-- create the alltests-fails.html at the root -->
		<redirect:write file="{$output.dir}/archive/alltests-fails.html">
			<xsl:apply-templates select="." mode="all.tests">
				<xsl:with-param name="type" select="'fails'" />
			</xsl:apply-templates>
		</redirect:write>

		<!-- create the alltests-errors.html at the root -->
		<redirect:write file="{$output.dir}/archive/alltests-errors.html">
			<xsl:apply-templates select="." mode="all.tests">
				<xsl:with-param name="type" select="'errors'" />
			</xsl:apply-templates>
		</redirect:write>
		
		<!-- create the alltests-successes.html at the root -->
		<redirect:write file="{$output.dir}/archive/alltests-successes.html">
			<xsl:apply-templates select="." mode="all.tests">
				<xsl:with-param name="type" select="'successes'" />
			</xsl:apply-templates>
		</redirect:write>

		<!-- process all packages -->
		<xsl:for-each
			select="./testsuite[not(./@package = preceding-sibling::testsuite/@package)]">
			<xsl:call-template name="package">
				<xsl:with-param name="name" select="@package" />
			</xsl:call-template>
		</xsl:for-each>
		

		
		
	</xsl:template>


	<xsl:template name="package">
		<xsl:param name="name" />
		<xsl:variable name="package.dir">
			<xsl:if test="not($name = '')">
				<xsl:value-of select="translate($name,'.','/')" />
			</xsl:if>
			<xsl:if test="$name = ''">
				.
			</xsl:if>
		</xsl:variable>
		<!--Processing package <xsl:value-of select="@name"/> in <xsl:value-of 
			select="$output.dir"/> -->
		<!-- create a classes-list.html in the package directory -->
		<redirect:write file="{$output.dir}/archive/{@id}_package-frame.html">
			<xsl:call-template name="classes.list">
				<xsl:with-param name="name" select="$name" />
			</xsl:call-template>
		</redirect:write>

		<!-- create a package-summary.html in the package directory -->
		<redirect:write file="{$output.dir}/archive/{@id}_package-summary.html">
			<xsl:call-template name="package.summary">
				<xsl:with-param name="name" select="$name" />
				<xsl:with-param name="id" select="@id" />
			</xsl:call-template>
		</redirect:write>
		
		
		
		<redirect:write file="{$output.dir}/archive/{@id}_package-alltests.html">
			<xsl:call-template name="package.all.tests">
				<xsl:with-param name="name" select="$name" />
				<xsl:with-param name="type" select=" 'tests' " />
			</xsl:call-template>
		</redirect:write>
		<redirect:write file="{$output.dir}/archive/{@id}_package-allfails.html">
			<xsl:call-template name="package.all.tests">
				<xsl:with-param name="name" select="$name" />
				<xsl:with-param name="type" select=" 'fails' " />
			</xsl:call-template>
		</redirect:write>
		<redirect:write file="{$output.dir}/archive/{@id}_package-allerrors.html">
			<xsl:call-template name="package.all.tests">
				<xsl:with-param name="name" select="$name" />
				<xsl:with-param name="type" select=" 'errors' " />
			</xsl:call-template>
		</redirect:write>
		<redirect:write file="{$output.dir}/archive/{@id}_package-allsuccesses.html">
			<xsl:call-template name="package.all.tests">
				<xsl:with-param name="name" select="$name" />
				<xsl:with-param name="type" select=" 'successes' " />
			</xsl:call-template>
		</redirect:write>
		
		

		<!-- for each class, creates a @name.html -->
		<!-- @bug there will be a problem with inner classes having the same name, 
			it will be overwritten -->
		<xsl:for-each select="/testsuites/testsuite[@package = $name]">
			<redirect:write file="{$output.dir}/archive/{@id}_{@name}.html">
				<xsl:apply-templates select="." mode="class.details" />
			</redirect:write>
			<xsl:if test="string-length(./system-out)!=0">
				<redirect:write
					file="{$output.dir}/archive/{@id}_{@name}-out.html">
					<html>
						<head>
							<title>
								Standard Output from
								<xsl:value-of select="@name" />
							</title>
						</head>
						<body>
							<pre>
								<xsl:value-of select="./system-out" />
							</pre>
						</body>
					</html>
				</redirect:write>
			</xsl:if>
			<xsl:if test="string-length(./system-err)!=0">
				<redirect:write
					file="{$output.dir}/archive/{@id}_{@name}-err.html">
					<html>
						<head>
							<title>
								Standard Error from
								<xsl:value-of select="@name" />
							</title>
						</head>
						<body>
							<pre>
								<xsl:value-of select="./system-err" />
							</pre>
						</body>
					</html>
				</redirect:write>
			</xsl:if>
			<xsl:if test="@failures != 0">
				<redirect:write
					file="{$output.dir}/archive/{@id}_{@name}-fails.html">
					<xsl:apply-templates select="." mode="class.details">
						<xsl:with-param name="type" select="'fails'" />
					</xsl:apply-templates>
				</redirect:write>
			</xsl:if>
			<xsl:if test="@errors != 0">
				<redirect:write
					file="{$output.dir}/archive/{@id}_{@name}-errors.html">
					<xsl:apply-templates select="." mode="class.details">
						<xsl:with-param name="type" select="'errors'" />
					</xsl:apply-templates>
				</redirect:write>
			</xsl:if>
          
			<xsl:variable name="success" select="(@tests - @failures - @errors)"/>


			<xsl:if test="$success != 0">
				<redirect:write
					file="{$output.dir}/archive/{@id}_{@name}-success.html">
					<xsl:apply-templates select="." mode="class.details">
						<xsl:with-param name="type" select="'success'" />
					</xsl:apply-templates>
				</redirect:write>
			</xsl:if>



		</xsl:for-each>
	</xsl:template>


   <xsl:template name="footer">
      	<footer>
  			<p>Report generated by SonnetTEST Framework</p>
		</footer>
   
   </xsl:template>

	<xsl:template name="index.html">
		<html>
			 <head>
				<title>
					<xsl:value-of select="$TITLE" />

					
				</title>
				
				
				
			</head> 
	
			
			<frameset cols="20%,80%">
			 <frameset rows="30%,70%">
					<frame src="./archive/overview-frame.html" name="packageListFrame" />
					<frame src="./archive/allclasses-frame.html" name="classListFrame" />
				</frameset>
				<frameset>
						<frame src="./archive/overview-summary.html" name="classFrame" />	
				</frameset>
				
			
				<noframes>
					<h2>Frame Alert</h2>
					<p>
						This document is designed to be viewed using the frames feature.
						If
						you see this message, you are using a non-frame-capable web
						client.
					</p>
				</noframes>
				
				
			</frameset>

		</html>
	</xsl:template>
	
	
		<xsl:template name="method.html">
		<html>
			 <head>
					<title>
					<xsl:value-of select="SonnetTest" />

					
				</title>
				<link rel="stylesheet" type="text/css" title="Style" href="./stylesheet.css"/>
				
					
			</head> 
			<body>
			<xsl:call-template name="pageHeader" />
			
			<table class="method" border="0" cellpadding="5" cellspacing="2"
					width="100%">
			
			    <tr>
							<th width="70%">Verification steps</th>
				
							<th width="30%">Screenshots</th>
				</tr>
			
			 
			
			   
			        
		      <xsl:choose>
					 <xsl:when test="@name">
					 <xsl:variable name="methodname" select="@name"/>
					 <xsl:variable name="classname" select="@classname"/>
					 <xsl:variable name="completename" select="concat($classname,'_', $methodname)" />
					   <xsl:for-each  select="document('TestSteps.xml')/testmethods/testmethod[@name=$completename]/teststep">
                       <xsl:variable name="status" select="@status"/>
                         <tr id="{$status}">
			       
			              <td>
                            <xsl:value-of select="description"/>    	       
			              </td>
			                 
							<td>
							       <xsl:variable name="screenshotname" select="screenshot"/>
									<a href="../screenshots/{$screenshotname}" target="screenshotpopup" 
  										onclick="window.open('../screenshots/{$screenshotname}','screenshotpopup','width=600,height=600'); return false;">
   						 				<img src="../screenshots/{$screenshotname}" width="150" height="90" />
									</a>

							
							
							   
							</td>
						
						</tr>
                       
                       
                       </xsl:for-each>
				
		             </xsl:when>
			        
		     </xsl:choose>
			
						
				
				</table>
			
			
			
			
			
			</body>
	
			


		</html>
	</xsl:template>
	
	
	
	
	
	
<xsl:template name="summarytable">
   <h2>Summary</h2>
	<table class="summary-details" border="0" cellpadding="5" cellspacing="2"
					width="100%">
					<tr valign="top">
						<th width="17%">URL</th>	
						<td>
						<xsl:value-of select="$URL"/>
				   		</td>
					</tr>	
						
					
					<tr valign="top">
				       <th width="17%">Browser Name</th>
				   	   <td>
						<xsl:value-of select="$BrowserName"/>
				      </td>
		
					</tr>
					
				<tr valign="top">
				      <th width="17%">Executed On</th>
				      <td>
						 <xsl:value-of select="$ExecutedOn"/>
				      </td>
				</tr>
					
				</table>
				
	
</xsl:template>	
	
	
	
	
	
	
	
	
	
	
	
	

	<!-- this is the stylesheet css to use for nearly everything -->
	<xsl:template name="stylesheet.css">
		body {
		font:normal 68% verdana,arial,helvetica;
		color:#000000;
		}
		table tr
		td, table tr th {
		font-size: 68%;
		}
		table.details tr th{
		font-weight:
		bold;
		text-align:left;
		background:#a6caf0;
		}
		table.details tr td{
		background:#eeeee0;
		}

		p {
		line-height:1.5em;
		margin-top:0.5em;
		margin-bottom:1.0em;
		}
		margin: 0px 0px 5px; font: 300%
		verdana,arial,helvetica
		}
		h2 {
		margin-top: 1em; margin-bottom: 0.5em;
		font: bold 125% verdana,arial,helvetica
		
		
		}
		h3 {
		margin-bottom: 0.5em;
		font: bold 115% verdana,arial,helvetica
		}
		h4 {
		margin-bottom: 0.5em;
		font: bold 100% verdana,arial,helvetica
		}
		h5 {
		margin-bottom: 0.5em;
		font: bold 100% verdana,arial,helvetica
		}
		h6 {
		margin-bottom: 0.5em;
		font: bold 100% verdana,arial,helvetica
		}
		.Error {
		font-weight:bold;
		color:#FF3333;
		
		}
		.Failure {
		font-weight:bold; 
		color:#CC0000;
		
		}
		
		.Pass{
		font-weight:bold; 
		color:#339933;
		}
		
		.TableRowColor{
		font-weight:bold; 
		color:#339933;
		}
		
		.Properties {
		text-align:right;
		display:none;
		
		}
		footer { 
         
            text-align: left;
             font-size: 95%;
              font-weight: bold;
                   
			   position:absolute;
			   bottom:0;
			   width:100%;
			   height:30px; 
               
              
        }
        
        h1,img{
 			 display: inline-block;
 				 margin: 0px;
  				vertical-align: middle;
  				
		}
        
        img{
          
                 float: right;
    			margin-bottom:2px;
        }
        
        img.stacktrace{
          
                 float: left;
    			
        }
        
      
        
        table.summary-details tr th{
		font-weight:
		bold;
		text-align:left;
		background:#a6caf0;
		font-size: 68%;
		}
		table.summary-details tr td{
		background:#eeeee0;
		font-size: 68%;
	    font-weight:
		bold;
		color:blue;
		}
		
		table.method tr th{
		font-weight:
		bold;
		text-align:left;
		background:#a6caf0;
		}
		
	    table.method tr td{
		background:#eeeee0;
		font-size: 80%;
	    font-weight:
		bold;
		color:blue;
		}
		.method img{
        width:100%; height:auto;
        }
        
	   div.stacktrace{
	    display:none;
	    height: 100px;
	    overflow: scroll;
	    font-size: 120%;
	    float:right;
	    font-weight:
		bold;
	   }
	   
	   
	   
	 .left {float:left;}
	 .right {float:right;}

      .hide{
     display:none;
     color:#eeeee0;
     }
	
     div#chart{
     float:right;
     
     }
     
     div#summarytable{
     float:left;
    
     }
	

	
		.scrollingtable {
	    
		  display: inline-block;
		  vertical-align: middle;
		  overflow-y: auto;
		  width: auto; 
		  min-width: 100%; 
		  height: 300px; 
	
		  
		 
		
		}
		
		.scrollingtablealltests{
	    
		  display: inline-block;
		  vertical-align: middle;
		  overflow-y: auto;
		  width: auto; 
		  min-width: 100%; 
		  height: 300px; 
	
		}
		

		table tr:hover{
		background:#99FF33;
		  color:blue;
		}

       table,h2,h3,hr,div{
        padding-bottom: 0;
      margin-top:0;
       margin-bottom:0cm;
       }
       
       hr{
        margin-bottom:0.1cm;
       }
       table.summary-details{
         margin-bottom:0.3cm;
       }
       
       tr#pass{
       bgcolor="#66FF00"
       }
       
       tr#failure{
       bgcolor="#FF0000"
       }
  

	</xsl:template>

	<!-- Create list of all/failed/errored tests -->
	<xsl:template match="testsuites" mode="all.tests">
		<xsl:param name="type" select="'all'" />
		
		
		
		
				<xsl:variable name="testCount" select="sum(testsuite/@tests)" />
				<xsl:variable name="errorCount" select="sum(testsuite/@errors)" />
				<xsl:variable name="failureCount" select="sum(testsuite/@failures)" />
				<xsl:variable name="successCount" select="($testCount - $failureCount - $errorCount)" />
				<xsl:variable name="timeCount" select="sum(testsuite/@time)" />
				<xsl:variable name="successRate"
					select="($testCount - $failureCount - $errorCount) div $testCount" />
		
		
		
		
		
		
		
		
		
		
		<html>
			<xsl:variable name="title">
				<xsl:choose>
					<xsl:when test="$type = 'fails'">
						<xsl:text>All Failures</xsl:text>
					</xsl:when>
					<xsl:when test="$type = 'errors'">
						<xsl:text>All Errors</xsl:text>
					</xsl:when>
					<xsl:when test="$type = 'successes'">
						<xsl:text>All Successes</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>All Tests</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<head>
				<title>
					SonnetTest Result:
					<xsl:value-of select="$title" />
				</title>
				<xsl:call-template name="create.stylesheet.link">
					<xsl:with-param name="package.name" />
				</xsl:call-template>
				 
		      <script language="javascript">
						function toggle(elementId,imageId,hideId) {
						    var ele = document.getElementById(elementId);
						    var img = document.getElementById(imageId);
						     var hide = document.getElementById(hideId);
						    if(ele.style.display == "block") {
						            ele.style.display = "none";
						             img.src="../test/img/expand.gif";
						              hide.style.display="none";
						             
						    }
						    else {
						        ele.style.display = "block";
						        img.src="../test/img/collapse.gif";
						        hide.style.display="block";
						    }
						}
						</script>


		   <script type="text/javascript" src="https://www.google.com/jsapi"></script>
				    <script type="text/javascript">
				    
				      google.load('visualization', '1.0', {'packages':['corechart']});
				      google.setOnLoadCallback(drawChart);
				
				      function drawChart() {
						 var data = new google.visualization.DataTable();
						 data.addColumn('string', 'TestStatus');
						 data.addColumn('number', 'Number_of_Tests');
						 data.addRows([
					        ['Errors', <xsl:value-of select="$errorCount"/>],
					        ['Failures', <xsl:value-of select="$failureCount"/>],
					        ['Successes', <xsl:value-of select="$successCount"/>], 
					      ]);
		 
					     
				      var options = {		 
				        width: 500,
				        height: 200,
				        colors: ['#FF3333', '#A00000', '#339933'],
				        legend: { position: 'left', maxLines: 1 },
				        is3D: true,
				        'chartArea': {'width': '75%', 'height': '90%'},
				      };
				
				        // Instantiate and draw our chart, passing in some options.
				        var chart = new google.visualization.PieChart(document.getElementById('chart_div_alltests'));
				        chart.draw(data, options);
				      }
				    </script>

                  	
			<style>
					html { overflow-y: hidden; }
					html { overflow-x: hidden; }
			  </style>
				
				
			</head>
			<body>
				<xsl:attribute name="onload">open('allclasses-frame.html','classListFrame')</xsl:attribute>
				
				<div id="logo">
		   		 <h1>
					<xsl:value-of select="$TITLE" />
		    	</h1>
		    	<img src="{$Product_Logo}"   alt="Mountain View" style="width:100px;height:50px;" />
				</div>
				
				<table width="100%"></table>	
				<hr size="1" />

                 
			<div width="100%">
			
			<div id="summarytable" style="width:52%">
				
				<xsl:call-template name="summarytable"/>
		      
		      	<h3>All Suites</h3>
		      
				<table class="details" border="0" cellpadding="5" cellspacing="2"
					width="100%">
					<tr valign="top">
						<th>Tests</th>
						<th>Failures</th>
						<th>Errors</th>
						<th>Successes</th>
						<th>Time(sec)</th>
					</tr>
					<tr valign="top">
						<xsl:attribute name="class">
                <xsl:choose>
                    <xsl:when test="$errorCount &gt; 0">Error</xsl:when>
                    <xsl:when test="$failureCount &gt; 0">Failure</xsl:when>
                    <xsl:otherwise>Pass</xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
						<td>
							<a title="Display all tests" href="all-tests.html">
								<xsl:value-of select="$testCount" />
							</a>
						</td>
						<td>
							<a title="Display all failures" href="alltests-fails.html">
								<xsl:value-of select="$failureCount" />
							</a>
						</td>
						<td>
							<a title="Display all errors" href="alltests-errors.html">
								<xsl:value-of select="$errorCount" />
							</a>
						</td>
						<td>
							<a title="Display all successes" href="alltests-successes.html">
								<xsl:value-of select="$testCount - $failureCount - $errorCount" />
							</a>
						</td>
	
						<td>
							<xsl:call-template name="display-time">
								<xsl:with-param name="value" select="$timeCount" />
							</xsl:call-template>
						</td>
					</tr>
				</table>
				
				
		   </div>	
				
			<div id="chart" style="width:48%">	
				 <div id="chart_div_alltests"></div>	
		  	</div>	
		  	
	        
			</div>	
                 
              
				<table width="100%">

				</table>   
            
				
				<h2>
					<xsl:value-of select="$title" />
				</h2>

                      
                 
                 


               <div class="scrollingtablealltests">
				<table class="details" border="0" cellpadding="5" cellspacing="2"
					width="100%">
					<xsl:call-template name="testcase.test.header">
						<xsl:with-param name="show.class" select="'yes'" />
					</xsl:call-template>
					<!-- test can even not be started at all (failure to load the class) 
						so report the error directly -->
					<xsl:if test="./error">
						<tr class="Error">
							<td colspan="4">
								<xsl:apply-templates select="./error" />
							</td>
						</tr>
					</xsl:if>
					<xsl:choose>
						<xsl:when test="$type = 'fails'">
							<xsl:apply-templates select=".//testcase[failure]"
								mode="print.test.all">
								<xsl:with-param name="show.class" select="'yes'" />
							</xsl:apply-templates>
						</xsl:when>
						<xsl:when test="$type = 'errors'">
							<xsl:apply-templates select=".//testcase[error]"
								mode="print.test.all">
								<xsl:with-param name="show.class" select="'yes'" />
							</xsl:apply-templates>
						</xsl:when>
						<xsl:when test="$type = 'successes'">
							<xsl:apply-templates select=".//testcase[not(error) and not(failure)]"
								mode="print.test.all">
								<xsl:with-param name="show.class" select="'yes'" />
							</xsl:apply-templates>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select=".//testcase"
								mode="print.test.all">
								<xsl:with-param name="show.class" select="'yes'" />
							</xsl:apply-templates>
						</xsl:otherwise>
					</xsl:choose>
				</table>
				</div>
				
				<xsl:call-template name="footer"></xsl:call-template>
				
			</body>
		</html>
	</xsl:template>




<!-- Create list of all/failed/errored tests in a package-->
	<xsl:template name="package.all.tests">
		<xsl:param name="type" select="'all'" />
		<xsl:param name="name" select="'' " />
		
		
		
		    	<xsl:variable name="suitetestCount" select="sum(//testsuite[@package = $name]/@tests)" />
			    <xsl:variable name="suiteerrorCount" select="sum(//testsuite[@package = $name]/@errors)" />
				<xsl:variable name="suitefailureCount" select="sum(//testsuite[@package = $name]/@failures)" />
				<xsl:variable name="suitesuccessCount" select="($suitetestCount - $suitefailureCount - $suiteerrorCount)" />	
			
		
		<html>
		
			<xsl:variable name="title">
				<xsl:choose>
					<xsl:when test="$type = 'fails'">
						<xsl:text>All Failures in the package :</xsl:text><xsl:value-of select="$name"/>
					</xsl:when>
					<xsl:when test="$type = 'errors'">
						<xsl:text>All Errors in the package :</xsl:text><xsl:value-of select="$name"/>
					</xsl:when>
					<xsl:when test="$type = 'successes'">
						<xsl:text>All Successes in the package :</xsl:text><xsl:value-of select="$name"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>All Tests in the package :</xsl:text> <xsl:value-of select="$name"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<head>
				<title>
					SonnetTest Result:
					<xsl:value-of select="$title" />
				</title>
				<xsl:call-template name="create.stylesheet.link">
					<xsl:with-param name="package.name" />
				</xsl:call-template>
									 
				<script language="javascript">
					function toggle(elementId,imageId,hideId) {
					    var ele = document.getElementById(elementId);
					    var img = document.getElementById(imageId);
					     var hide = document.getElementById(hideId);
					    if(ele.style.display == "block") {
					            ele.style.display = "none";
					             img.src="../test/img/expand.gif";
					              hide.style.display="none";
					             
					    }
					    else {
					        ele.style.display = "block";
					        img.src="../test/img/collapse.gif";
					        hide.style.display="block";
					    }
					}
					</script>
					
					
			<script type="text/javascript" src="https://www.google.com/jsapi"></script>
		    <script type="text/javascript">
		    
		      google.load('visualization', '1.0', {'packages':['corechart']});
		      google.setOnLoadCallback(drawChart);
		
		      function drawChart() {
				 var data = new google.visualization.DataTable();
				 data.addColumn('string', 'TestStatus');
				 data.addColumn('number', 'Number_of_Tests');
				 data.addRows([
			        ['Errors', <xsl:value-of select="$suiteerrorCount"/>],
			        ['Failures', <xsl:value-of select="$suitefailureCount"/>],
			        ['Successes', <xsl:value-of select="$suitesuccessCount"/>], 
			      ]);
 
			     
		      var options = {		 
		        width: 500,
		        height: 200,
		        colors: ['#FF3333', '#A00000', '#339933'],
		        legend: { position: 'left', maxLines: 1 },
		        is3D: true,
                 'chartArea': {'width': '75%', 'height': '90%'},
		      };
		
		        // Instantiate and draw our chart, passing in some options.
		        var chart = new google.visualization.PieChart(document.getElementById('chart_div_alltests_in_suite'));
		        chart.draw(data, options);
		      }
		    </script>
					
									
				
			</head>
			<body>
				
				<div id="logo">
		   		 <h1>
					<xsl:value-of select="$TITLE" />
		    	</h1>
		    	<img src="{$Product_Logo}"   alt="Mountain View" style="width:100px;height:50px;" />
				</div>
				
				<table width="100%"></table>	
				<hr size="1" />

				
				
				
			<div width="100%">		
				<div id="summarytable" style="width:52%">
				<xsl:call-template name="summarytable"/>
				
				
				
				<h3>
					Test Suite:
					<xsl:value-of select="$name" />
				
				</h3>

			   <table class="details" border="0" cellpadding="5" cellspacing="2"
					width="100%">
					<tr valign="top">
						<th>Tests</th>
						<th>Failures</th>
						<th>Errors</th>
						<th>Successes</th>			
						<th>Time(sec)</th>
					</tr>
					<tr valign="top">
					     <xsl:attribute name="class">
							                <xsl:choose>
							                    <xsl:when test="$suiteerrorCount &gt; 0">Error</xsl:when>
							                    <xsl:when test="$suitefailureCount &gt; 0">Failure</xsl:when>
							                    <xsl:otherwise>Pass</xsl:otherwise>
							                </xsl:choose>
					      </xsl:attribute>
						
					
						<td>
						    <a title="Display all tests in a package" href="{@id}_package-alltests.html">
							<xsl:value-of select="$suitetestCount" />
							</a>
						</td>
						<td>
						  
						 <xsl:choose>
						 <xsl:when test="$suitefailureCount != 0">
							<a title="Display all failures in a package" href="{@id}_package-allfails.html">
								<xsl:value-of select="$suitefailureCount" />
							</a>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$suitefailureCount" />
						</xsl:otherwise>
						 </xsl:choose> 
						</td>
						   
						<td>
						 <xsl:choose>
						 <xsl:when test="$suiteerrorCount != 0">
						   <a title="Display all errors in a package" href="{@id}_package-allerrors.html">
							<xsl:value-of select="$suiteerrorCount" />
							</a>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$suiteerrorCount" />
						</xsl:otherwise>
						</xsl:choose>
						</td>
							
						<td>
						 <xsl:choose>
						<xsl:when test="$suitesuccessCount != 0">
						  	<a title="Display all successes in a package" href="{@id}_package-allsuccesses.html">
							<xsl:value-of select="$suitesuccessCount" />
							</a>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$suitesuccessCount" />
						</xsl:otherwise>
						</xsl:choose>
						</td>
						<td>
							<xsl:call-template name="display-time">
								<xsl:with-param name="value" select="sum(//testsuite[@package = $name]/@time)" />
							</xsl:call-template>

						</td>
	                  </tr>
               </table>
      
               </div>
               
               		<div id="chart" style="width:48%">
               
               				<div id="chart_div_alltests_in_suite"></div>	
            	
					
		  			</div>	
            </div> 
				
				
				
				<table width="100%"/>
				
				
				
				
				
				
				
				<h2>
					<xsl:value-of select="$title" />
				</h2>

					<div class="scrollingtablealltests">
				<table class="details" border="0" cellpadding="5" cellspacing="2"
					width="100%">
					<xsl:call-template name="testcase.test.header">
						<xsl:with-param name="show.class" select="'yes'" />
					</xsl:call-template>
					<!-- test can even not be started at all (failure to load the class) 
						so report the error directly -->
					<xsl:if test="./error">
						<tr class="Error">
							<td colspan="4">
								<xsl:apply-templates select="./error" />
							</td>
						</tr>
					</xsl:if>
					<xsl:choose>
						<xsl:when test="$type = 'fails'">
							<xsl:apply-templates select="//testsuite[@package=$name]/testcase[failure]"
								mode="print.test.all">
								<xsl:with-param name="show.class" select="'yes'" />
							</xsl:apply-templates>
						</xsl:when>
						<xsl:when test="$type = 'errors'">
							<xsl:apply-templates select="//testsuite[@package=$name]/testcase[error]"
								mode="print.test.all">
								<xsl:with-param name="show.class" select="'yes'" />
							</xsl:apply-templates>
						</xsl:when>
						<xsl:when test="$type = 'successes'">
							<xsl:apply-templates select="//testsuite[@package=$name]/testcase[not(error) and not(failure)]"
								mode="print.test.all">
								<xsl:with-param name="show.class" select="'yes'" />
							</xsl:apply-templates>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select="//testsuite[@package=$name]/testcase"
								mode="print.test.all">
								<xsl:with-param name="show.class" select="'yes'" />
							</xsl:apply-templates>
						</xsl:otherwise>
					</xsl:choose>
				</table>
				</div>
				<xsl:call-template name="footer"></xsl:call-template>
              
			</body>
		</html>
	</xsl:template>





	<!-- ====================================================================== 
		This page is created for every testsuite class. It prints a summary of the 
		testsuite and detailed information about testcase methods. ====================================================================== -->
	<xsl:template match="testsuite" mode="class.details">
		<xsl:param name="type" select="'all'" />
		<xsl:variable name="package.name" select="@package" />
		<xsl:variable name="class.name">
			<xsl:if test="not($package.name = '')">
				<xsl:value-of select="$package.name" />
				.
			</xsl:if>
			<xsl:value-of select="@name" />
		</xsl:variable>
		
		
				<xsl:variable name="classtestCount" select="@tests"/>
				<xsl:variable name="classerrorCount" select="@errors"/>
				<xsl:variable name="classfailureCount" select="@failures"/>
				<xsl:variable name="classsuccessCount" select="($classtestCount - $classerrorCount - $classfailureCount)"/>
		
		
		
		<html>
			<head>
				<title>
					SonnetTest Result:
					<xsl:value-of select="$class.name" />
				</title>
				<xsl:call-template name="create.stylesheet.link">
					<xsl:with-param name="package.name" select="$package.name" />
				</xsl:call-template>
				<script type="text/javascript" language="JavaScript">
					var TestCases = new Array();
					var cur;
					
				</script>
				<script type="text/javascript" language="JavaScript"><![CDATA[
        function displayProperties (name) {
          var win = window.open('','JUnitSystemProperties','scrollbars=1,resizable=1');
          var doc = win.document;
          doc.open();
          doc.write("<html><head><title>Properties of " + name + "</title>");
          doc.write("<style type=\"text/css\">");
          doc.write("body {font:normal 68% verdana,arial,helvetica; color:#000000; }");
          doc.write("table tr td, table tr th { font-size: 68%; }");
          doc.write("table.properties { border-collapse:collapse; border-left:solid 1 #cccccc; border-top:solid 1 #cccccc; padding:5px; }");
          doc.write("table.properties th { text-align:left; border-right:solid 1 #cccccc; border-bottom:solid 1 #cccccc; background-color:#eeeeee; }");
          doc.write("table.properties td { font:normal; text-align:left; border-right:solid 1 #cccccc; border-bottom:solid 1 #cccccc; background-color:#fffffff; }");
          doc.write("h3 { margin-bottom: 0.5em; font: bold 115% verdana,arial,helvetica }");
          doc.write("</style>");
          doc.write("</head><body>");
          doc.write("<h3>Properties of " + name + "</h3>");
          doc.write("<div align=\"right\"><a href=\"javascript:window.close();\">Close</a></div>");
          doc.write("<table class='properties'>");
          doc.write("<tr><th>Name</th><th>Value</th></tr>");
          for (prop in TestCases[name]) {
            doc.write("<tr><th>" + prop + "</th><td>" + TestCases[name][prop] + "</td></tr>");
          }
          doc.write("</table>");
          doc.write("</body></html>");
          doc.close();
          win.focus();
        }
      ]]>
				</script>
				
		<script language="javascript">
				function toggle(elementId,imageId,hideId) {
			    var ele = document.getElementById(elementId);
			    var img = document.getElementById(imageId);
			    var hide = document.getElementById(hideId);
			    if(ele.style.display == "block") {
			            ele.style.display = "none";
			             img.src="../test/img/expand.gif";
			             hide.style.display="none";
			    }
			    else {
			        ele.style.display = "block";
			        img.src="../test/img/collapse.gif";
			        hide.style.display="block";
			    }
			}
		</script>

				
				
		   <script type="text/javascript" src="https://www.google.com/jsapi"></script>
		    <script type="text/javascript">
		    
		      google.load('visualization', '1.0', {'packages':['corechart']});
		      google.setOnLoadCallback(drawChart);
		
		      function drawChart() {
				 var data = new google.visualization.DataTable();
				 data.addColumn('string', 'TestStatus');
				 data.addColumn('number', 'Number_of_Tests');
				 data.addRows([
			        ['Errors', <xsl:value-of select="$classerrorCount"/>],
			        ['Failures', <xsl:value-of select="$classfailureCount"/>],
			        ['Successes', <xsl:value-of select="$classsuccessCount"/>], 
			      ]);
 
			     
		      var options = {		 
		        width: 500,
		        height: 200,
		        colors: ['#FF3333', '#A00000', '#339933'],
		        legend: { position: 'left', maxLines: 1 },
		        is3D: true,
		         'chartArea': {'width': '75%', 'height': '90%'},
		      };
		
		        // Instantiate and draw our chart, passing in some options.
		        var chart = new google.visualization.PieChart(document.getElementById('chart_div_acrossmethods'));
		        chart.draw(data, options);
		      }
		    </script>
		    
				
			<style>
					html { overflow-y: hidden; }
					html { overflow-x: hidden; }
			  </style>
				
				
				
				
				
				
			</head>
			<body>
				<xsl:call-template name="pageHeader" />
				

				
				
				
	   <div width="100%">		
          <div id="summarytable" style="width:52%">	

				
				<xsl:call-template name="summarytable" />
		
				<h3>
					Test Script:
				  	<xsl:value-of select="$class.name" />
				</h3>
				
				
				
				
		
				<table class="details" border="0" cellpadding="5" cellspacing="2"
					width="100%">
					<xsl:call-template name="testsuite.test.header.method" />
					<xsl:apply-templates select="." mode="print.test.method">
					    <xsl:with-param name="count" select="$classsuccessCount" />
					</xsl:apply-templates>
				</table>
			
				  
			</div>
				
			  <div id="chart" style="width:48%">	
			  
			  <div id="chart_div_acrossmethods"></div>	
			  					
		  	</div>	
				
				
			</div>	
				
				
				
			<table width="100%">

			</table>	
				
				
				
				
				
				
				
				

				<xsl:choose>
					<xsl:when test="$type = 'fails'">
						<h2>Failures</h2>
					</xsl:when>
					<xsl:when test="$type = 'errors'">
						<h2>Errors</h2>
					</xsl:when>
					<xsl:when test="$type = 'success'">
						<h2>Successes</h2>
					</xsl:when>
					<xsl:otherwise>
						<h2>Tests</h2>
					</xsl:otherwise>
				</xsl:choose>
				
				<div class="scrollingtable">
				<table class="details" border="0" cellpadding="5" cellspacing="2"
					width="100%">
				
					<xsl:call-template name="testcase.test.header" />
				  
					<!-- test can even not be started at all (failure to load the class) 
						so report the error directly -->
				
					<xsl:if test="./error">
						<tr class="Error">
							<td colspan="4">
								<xsl:apply-templates select="./error" />
							</td>
						</tr>
					</xsl:if>
					<xsl:choose>
						<xsl:when test="$type = 'fails'">
							<xsl:apply-templates select="./testcase[failure]"
								mode="print.test" />
						</xsl:when>
						<xsl:when test="$type = 'errors'">
							<xsl:apply-templates select="./testcase[error]"
								mode="print.test" />
						</xsl:when>
						<xsl:when test="$type = 'success'"><!--selecting only passed testcases in a class -->
							<xsl:apply-templates select="./testcase[not(error) and not(failure)]"
								mode="print.test" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select="./testcase"
								mode="print.test" />
						</xsl:otherwise>
					</xsl:choose> 
				
				</table>
				</div>
				<div class="Properties">
					<a>
						<xsl:attribute name="href">javascript:displayProperties('<xsl:value-of
							select="@package" />.<xsl:value-of select="@name" />');</xsl:attribute>
						Properties &#187;
					</a>
				</div>
				<xsl:if test="string-length(./system-out)!=0">
					<div class="Properties">
						<a>
							<xsl:attribute name="href">./<xsl:value-of
								select="@id" />_<xsl:value-of select="@name" />-out.html</xsl:attribute>
							System.out &#187;
						</a>
					</div>
				</xsl:if>
				<xsl:if test="string-length(./system-err)!=0">
					<div class="Properties">
						<a>
							<xsl:attribute name="href">./<xsl:value-of
								select="@id" />_<xsl:value-of select="@name" />-err.html</xsl:attribute>
							System.err &#187;
						</a>
					</div>
				</xsl:if>
				
			    <xsl:call-template name="footer"></xsl:call-template>
				
				
			</body>
		</html>
	</xsl:template>

	<!-- Write properties into a JavaScript data structure. This is based on 
		the original idea by Erik Hatcher (ehatcher@apache.org) -->
	


	<!-- ====================================================================== 
		This page is created for every package. It prints the name of all classes 
		that belongs to this package. @param name the package name to print classes. 
		====================================================================== -->
	<!-- list of classes in a package -->
	<xsl:template name="classes.list">
		<xsl:param name="name" />
		<html>
			<head>
				<title>
					SonnetTest Classes:
					<xsl:value-of select="$name" />
				</title>
				<xsl:call-template name="create.stylesheet.link">
					<xsl:with-param name="package.name" select="$name" />
				</xsl:call-template>
			</head>
			<body>
				<table width="100%">
					<tr>
						<td nowrap="nowrap">
							<h2>
								<a href="{@id}_package-summary.html" target="classFrame">
									<xsl:value-of select="$name" />
									<xsl:if test="$name = ''">
										&lt;none&gt;
									</xsl:if>
								</a>
							</h2>
						</td>
					</tr>
				</table>

				<h2>Classes</h2>
				<table width="100%">
					<xsl:for-each select="/testsuites/testsuite[./@package = $name]">
						<xsl:sort select="@name" />
						<tr>
							<td nowrap="nowrap">
								<a href="{@id}_{@name}.html" target="classFrame">
									<xsl:value-of select="@name" />
								</a>
							</td>
						</tr>
					</xsl:for-each>
				</table>
				
		
			</body>
		</html>
	</xsl:template>


	<!-- Creates an all-classes.html file that contains a link to all package-summary.html 
		on each class. -->
	<xsl:template match="testsuites" mode="all.classes">
		<html>
			<head>
				<title>All Unit Test Classes</title>
				<xsl:call-template name="create.stylesheet.link">
					<xsl:with-param name="package.name" />
				</xsl:call-template>
			</head>
			<body>
				<h2>Test Scripts</h2>
				<table width="100%">
					<xsl:apply-templates select="testsuite" mode="all.classes">
						<xsl:sort select="@name" />
					</xsl:apply-templates>
				</table>
			</body>
		</html>
	</xsl:template>

	<xsl:template match="testsuite" mode="all.classes">
		<xsl:variable name="package.name" select="@package" />
		<tr>
			<td nowrap="nowrap">
				<a target="classFrame">
					<xsl:attribute name="href">
                    <xsl:value-of select="@id" />_<xsl:value-of
						select="@name" /><xsl:text>.html</xsl:text>
                </xsl:attribute>
					<xsl:value-of select="@name" />
				</a>
			</td>
		</tr>
	</xsl:template>


	<!-- Creates an html file that contains a link to all package-summary.html 
		files on each package existing on testsuites. @bug there will be a problem 
		here, I don't know yet how to handle unnamed package :( -->
	<xsl:template match="testsuites" mode="all.packages">
		<html>
			<head>
				<title>All Unit Test Packages</title>
				<xsl:call-template name="create.stylesheet.link">
					<xsl:with-param name="package.name" />
				</xsl:call-template>
			</head>
			<body>
				<h2>
					<a href="overview-summary.html" target="classFrame">Home</a>
				</h2>
				<h2>Test Suites</h2>
			    
				<table width="100%">
					<xsl:apply-templates
						select="testsuite[not(./@package = preceding-sibling::testsuite/@package)]"
						mode="all.packages">
						<xsl:sort select="@package" />
					</xsl:apply-templates>
				</table>
				
			</body>
		</html>
	</xsl:template>

	<xsl:template match="testsuite" mode="all.packages">
		<tr>
			<td nowrap="nowrap">
				<a href="./{@id}_package-summary.html"
					target="classFrame">
					<xsl:value-of select="@package" />
					<xsl:if test="@package = ''">
						&lt;none&gt;
					</xsl:if>
				</a>
			</td>
		</tr>
	</xsl:template>
	
	
	
	
	<xsl:template  name="graphdata_acrosssuites">
		  <xsl:for-each
						select="testsuite[not(./@package = preceding-sibling::testsuite/@package)]">
						<xsl:sort select="@package" order="ascending" />
					
						<xsl:variable name="insamepackage"
							select="/testsuites/testsuite[./@package = current()/@package]" />
                       <xsl:variable name="testcount" select="sum($insamepackage/@tests)"/>
                       <xsl:variable name="failurecount" select="sum($insamepackage/@failures)"/>
                       <xsl:variable name="errorcount" select="sum($insamepackage/@errors)"/> 
                       <xsl:variable name="successcount" select="($testcount - $failurecount - $errorcount)"/>
                       data.addRow(['<xsl:value-of select="@package" />',<xsl:value-of select="$errorcount" />, <xsl:value-of select="$failurecount" />, <xsl:value-of select="$successcount" />]);
                       
		</xsl:for-each>
	</xsl:template>
	
	
	
	<xsl:template  name="graphdata_acrossclasses">
	   <xsl:param name="name"/>
		
				  <xsl:for-each select="/testsuites/testsuite[./@package = $name]">
				      <xsl:sort select="@name" order="ascending" />
				 	   <xsl:variable name="testcount" select="@tests"/>
                       <xsl:variable name="failurecount" select="@failures"/>
                       <xsl:variable name="errorcount" select="@errors"/> 
                       <xsl:variable name="successcount" select="($testcount - $failurecount - $errorcount)"/>
				
	         			 data.addRow(['<xsl:value-of select="@name"/>',<xsl:value-of select="$errorcount"/>, <xsl:value-of select="$failurecount"/>, <xsl:value-of select="$successcount"/>]);
				</xsl:for-each>
	</xsl:template>
	
	
	


	<xsl:template match="testsuites" mode="overview.packages">
	    	
				<xsl:variable name="testCount" select="sum(testsuite/@tests)" />
				<xsl:variable name="errorCount" select="sum(testsuite/@errors)" />
				<xsl:variable name="failureCount" select="sum(testsuite/@failures)" />
				<xsl:variable name="successCount" select="($testCount - $failureCount - $errorCount)" />
				<xsl:variable name="timeCount" select="sum(testsuite/@time)" />
				<xsl:variable name="successRate"
					select="($testCount - $failureCount - $errorCount) div $testCount" />
	
		<html>
			<head>
				<title>SonnetTest Result: Summary</title>
				<!-- <xsl:call-template name="create.stylesheet.link">
					<xsl:with-param name="package.name" />
				</xsl:call-template> -->
				

						
		    <script type="text/javascript" src="https://www.google.com/jsapi"></script>
		    <script type="text/javascript">
		    
		      google.load('visualization', '1.0', {'packages':['corechart']});
		      google.setOnLoadCallback(drawChart);
		
		      function drawChart() {
				 var data = new google.visualization.DataTable();
				 data.addColumn('string', 'Suitename');
				 data.addColumn('number', 'Error');
				 data.addColumn('number', 'Failure');
				 data.addColumn('number', 'Success');

			   

				<xsl:call-template name="graphdata_acrosssuites"></xsl:call-template>
			   
			     
		      var options = {		 
		        width: 500,
		        height: 200,
		        legend: { position: 'top', maxLines: 1 },
		        bar: { groupWidth: '50%' },
		        isStacked: true,
		        colors: ['#FF3333', '#A00000', '#339933'],
		       'chartArea': {'width': '90%', 'height': '70%'},
		     
		      };
		
		        // Instantiate and draw our chart, passing in some options.
		        var chart = new google.visualization.ColumnChart(document.getElementById('chart_div'));
		        chart.draw(data, options);
		      }
		    </script>
		    
		    <script type="text/javascript">
		    window.onload = function() {
		    	loadcssfile("./stylesheet.css");
		    };
		    
		    
		    function loadcssfile(filename){                                                                                                                                                                                                                                                     
		            var fileref=document.createElement("link")
		            fileref.setAttribute("rel", "stylesheet")
		            fileref.setAttribute("type", "text/css")
		            fileref.setAttribute("title", "Style")
		            fileref.setAttribute("href", filename)
		            fileref.setAttribute("class", "__web-inspector-hide-shortcut-style__")
		            document.getElementsByTagName("head")[0].appendChild(fileref)
		    }
		    
		    </script>
		    <style id="__web-inspector-hide-shortcut-style__" type="text/css">
			.__web-inspector-hide-shortcut__, .__web-inspector-hide-shortcut__ *, .__web-inspector-hidebefore-shortcut__::before, .__web-inspector-hideafter-shortcut__::after
			{
			    visibility: hidden !important;
			}
			</style>
		    
				<style>
					html { overflow-y: hidden; }
					html { overflow-x: hidden; }
			  </style>
									




				
			</head>
			<body>
				<xsl:attribute name="onload">open('allclasses-frame.html','classListFrame')</xsl:attribute>
				
				 <div id="logo">
		    		<h1>
						<xsl:value-of select="$TITLE" />
		   		    </h1>
		    		<img src="{$Product_Logo}"   alt="Logo" style="width:100px;height:50px;" />
				</div>
		
		<table width="100%">

		</table>
		<hr size="1" />
		
			<div width="100%">
			
			<div id="summarytable" style="width:52%">
				
				<xsl:call-template name="summarytable"/>
		      
		      	<h3>All Suites</h3>
		      
				<table class="details" border="0" cellpadding="5" cellspacing="2"
					width="100%">
					<tr valign="top">
						<th>Tests</th>
						<th>Failures</th>
						<th>Errors</th>
						<th>Successes</th>
						<th>Time(sec)</th>
					</tr>
					<tr valign="top">
						<xsl:attribute name="class">
                <xsl:choose>
                    <xsl:when test="$errorCount &gt; 0">Error</xsl:when>
                    <xsl:when test="$failureCount &gt; 0">Failure</xsl:when>
                    <xsl:otherwise>Pass</xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
						<td>
							<a title="Display all tests" href="all-tests.html">
								<xsl:value-of select="$testCount" />
							</a>
						</td>
						<td>
							<a title="Display all failures" href="alltests-fails.html">
								<xsl:value-of select="$failureCount" />
							</a>
						</td>
						<td>
							<a title="Display all errors" href="alltests-errors.html">
								<xsl:value-of select="$errorCount" />
							</a>
						</td>
						<td>
							<a title="Display all successes" href="alltests-successes.html">
								<xsl:value-of select="$testCount - $failureCount - $errorCount" />
							</a>
						</td>

						<td>
							<xsl:call-template name="display-time">
								<xsl:with-param name="value" select="$timeCount" />
							</xsl:call-template>
						</td>
					</tr>
				</table>
				
				
		   </div>	
				
			
			<div id="chart" style="width:48%">	
				 <div id="chart_div"></div>	
		  	</div>	
		  	
	        
			</div>	
			
				<table width="100%">

		</table>
           
				<h2>Test Suites</h2>
				<div class="scrollingtable">
				
				<table class="details" border="0" cellpadding="5" cellspacing="2"
					width="100%">
					
					<xsl:call-template name="testsuite.test.header" />
					
					
					<xsl:for-each
						select="testsuite[not(./@package = preceding-sibling::testsuite/@package)]">
						<xsl:sort select="@package" order="ascending" />
						<!-- get the node set containing all testsuites that have the same 
							package -->
						<xsl:variable name="insamepackage"
							select="/testsuites/testsuite[./@package = current()/@package]" />
						<tr valign="top">
							<!-- display a failure if there is any failure/error in the package -->
							<xsl:attribute name="class">
                        <xsl:choose>
                            <xsl:when
								test="sum($insamepackage/@errors) &gt; 0">Error</xsl:when>
                            <xsl:when
								test="sum($insamepackage/@failures) &gt; 0">Failure</xsl:when>
                            <xsl:otherwise>Pass</xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
							<td>
								<a href="./{@id}_package-summary.html">
									<xsl:value-of select="@package" />
									<xsl:if test="@package = ''">
										&lt;none&gt;
									</xsl:if>
								</a>
							</td>
							<td>
								<xsl:value-of select="sum($insamepackage/@tests)" />
								
							</td>
							<td>
								<xsl:value-of select="sum($insamepackage/@errors)" />
							</td>
							<td>
								<xsl:value-of select="sum($insamepackage/@failures)" />
							</td>
							
							<td>
							   <xsl:variable name="totaltests" select="sum($insamepackage/@tests)"/>
							   <xsl:variable name="errors" select="sum($insamepackage/@errors)"/>
							    <xsl:variable name="failures" select="sum($insamepackage/@failures)"/>
								<xsl:value-of select="$totaltests -$errors -$failures" />	
							</td>
							
							<td>
								<xsl:call-template name="display-time">
									<xsl:with-param name="value" select="sum($insamepackage/@time)" />
								</xsl:call-template>
							</td>
							<td>
								<xsl:value-of select="$insamepackage/@timestamp" />
							</td>
							<!-- <td><xsl:value-of select="$insamepackage/@hostname"/></td> -->
						</tr>
					</xsl:for-each>
					
				</table>
				</div>
				
				
				
				<xsl:call-template name="footer"></xsl:call-template>
				
				
				
				
			</body>
		</html>
	</xsl:template>


	<xsl:template name="package.summary">
		<xsl:param name="name" />
		<xsl:param name="id" />
		<html>
			<head>
				<xsl:call-template name="create.stylesheet.link">
					<xsl:with-param name="package.name" select="$name" />
				</xsl:call-template>
				
				
							  <!--Load the AJAX API-->
		    <script type="text/javascript" src="https://www.google.com/jsapi"></script>
		    <script type="text/javascript">
		    
		      google.load('visualization', '1.0', {'packages':['corechart']});
		      google.setOnLoadCallback(drawChart);
		
		      function drawChart() {
				 var data = new google.visualization.DataTable();
				 data.addColumn('string', 'Classnames');
				 data.addColumn('number', 'Errors');
				 data.addColumn('number', 'Failures');
				 data.addColumn('number', 'Successes');

			   

				<xsl:call-template name="graphdata_acrossclasses">
					<xsl:with-param name="name" select="$name"/>
				</xsl:call-template>
			   
			     
		      var options = {		 
		        width: 500,
		        height: 200,
		        legend: { position: 'top', maxLines: 1 },
		        bar: { groupWidth: '50%' },
		        isStacked: true,
		       colors: ['#FF3333', '#A00000', '#339933'], 
		       'chartArea': {'width': '90%', 'height': '70%'},
		       // series: [{color: 'pink', visibleInLegend: true}, {color: 'red', visibleInLegend: true}, {color: 'green', visibleInLegend: true}]
		      };
		
		        // Instantiate and draw our chart, passing in some options.
		        var chart = new google.visualization.ColumnChart(document.getElementById('chart_div_acrossclasses'));
		        chart.draw(data, options);
		      }
		    </script>
		    	<style>
					html { overflow-y: hidden; }
					html { overflow-x: hidden; }
			  </style>
				
				
				
			</head>
			<body>
			
			<xsl:variable name="id.href">
			<xsl:value-of
				select="concat( $id,'_','package-frame.html')" />
		    </xsl:variable>	
		    
		 
		    
		    	<xsl:variable name="suitetestCount" select="sum(//testsuite[@package = $name]/@tests)" />
			    <xsl:variable name="suiteerrorCount" select="sum(//testsuite[@package = $name]/@errors)" />
				<xsl:variable name="suitefailureCount" select="sum(//testsuite[@package = $name]/@failures)" />
				<xsl:variable name="suitesuccessCount" select="($suitetestCount - $suitefailureCount - $suiteerrorCount)" />	
			
			  
				<xsl:attribute name="onload">open('<xsl:value-of select="$id.href" />','classListFrame')</xsl:attribute>
				<xsl:call-template name="pageHeader" />
				
			<div width="100%">		
				<div id="summarytable" style="width:52%">
				<xsl:call-template name="summarytable"/>
				
				
				
				<h3>
					Test Suite:
					<xsl:value-of select="$name" />
				
				</h3>

			   <table class="details" border="0" cellpadding="5" cellspacing="2"
					width="100%">
					<tr valign="top">
						<th>Tests</th>
						<th>Failures</th>
						<th>Errors</th>
						<th>Successes</th>
						<th>Time(sec)</th>
					</tr>
					<tr valign="top">
					
					    
						
							<xsl:attribute name="class">
							                <xsl:choose>
							                    <xsl:when test="$suiteerrorCount &gt; 0">Error</xsl:when>
							                    <xsl:when test="$suitefailureCount &gt; 0">Failure</xsl:when>
							                    <xsl:otherwise>Pass</xsl:otherwise>
							                </xsl:choose>
					        </xsl:attribute>
					
					
						<td>
						    <a title="Display all tests in a package" href="{@id}_package-alltests.html">
							<xsl:value-of select="$suitetestCount" />
							</a>
						</td>
						<td>
						  
						 <xsl:choose>
						 <xsl:when test="$suitefailureCount != 0">
							<a title="Display all failures in a package" href="{@id}_package-allfails.html">
								<xsl:value-of select="$suitefailureCount" />
							</a>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$suitefailureCount" />
						</xsl:otherwise>
						 </xsl:choose> 
						</td>
						   
						<td>
						 <xsl:choose>
						 <xsl:when test="$suiteerrorCount != 0">
						   <a title="Display all errors in a package" href="{@id}_package-allerrors.html">
							<xsl:value-of select="$suiteerrorCount" />
							</a>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$suiteerrorCount" />
						</xsl:otherwise>
						</xsl:choose>
						</td>
							
						<td>
						 <xsl:choose>
						<xsl:when test="$suitesuccessCount != 0">
						  	<a title="Display all successes in a package" href="{@id}_package-allsuccesses.html">
							<xsl:value-of select="$suitesuccessCount" />
							</a>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$suitesuccessCount" />
						</xsl:otherwise>
						</xsl:choose>
						</td>
						
						<td>
							<xsl:call-template name="display-time">
								<xsl:with-param name="value" select="sum(//testsuite[@package = $name]/@time)" />
							</xsl:call-template>

						</td>
						
						
	                  </tr>
               </table>
      
               </div>
               
               		<div id="chart" style="width:48%">
               
               				<div id="chart_div_acrossclasses"></div>	
            	
					
		  			</div>	
            </div>   
               	<table width="100%"/>
				<xsl:variable name="insamepackage"
					select="/testsuites/testsuite[./@package = $name]" />
				<xsl:if test="count($insamepackage) &gt; 0">
					<h2>Test Scripts</h2>
						<div class="scrollingtable">
						<table class="details" border="0" cellpadding="5"
							cellspacing="2" width="100%">
							<xsl:call-template name="testsuite.test.header" />
					  		<xsl:apply-templates select="$insamepackage"
								mode="print.test">
								
								<xsl:sort select="@name" />
							</xsl:apply-templates>
						</table>
					  
					   </div>
				</xsl:if>
				
			<xsl:call-template name="footer"></xsl:call-template>	
				
			</body>
		</html>
	</xsl:template>


	<!-- transform string like a.b.c to ../../../ @param path the path to transform 
		into a descending directory path -->
	<xsl:template name="path">
		<xsl:param name="path" />
		<xsl:if test="contains($path,'.')">
			<xsl:text>../</xsl:text>
			<xsl:call-template name="path">
				<xsl:with-param name="path">
					<xsl:value-of select="substring-after($path,'.')" />
				</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
		<xsl:if test="not(contains($path,'.')) and not($path = '')">
			<xsl:text>../</xsl:text>
		</xsl:if>
	</xsl:template>


	<!-- create the link to the stylesheet based on the package name -->
	<xsl:template name="create.stylesheet.link">
		<xsl:param name="package.name" />
		<link rel="stylesheet" type="text/css" title="Style" href="./stylesheet.css">
		</link>
	</xsl:template>


	<!-- Page HEADER -->
	<xsl:template name="pageHeader">
	
	    <div id="logo">
		    <h1>
				<xsl:value-of select="$TITLE" />
		    </h1>
		    <img src="{$Product_Logo}"   alt="Mountain View" style="width:100px;height:50px;" />
		</div>
		
		<table width="100%">

		</table>
		<hr size="1" />
	</xsl:template>

	<!-- class header -->
	<xsl:template name="testsuite.test.header">
		<tr valign="top">
			<th width="40%">Name</th>
			<th>Tests</th>
			<th>Errors</th>
			<th>Failures</th>
			<th>Successes</th>
			<th nowrap="nowrap">Time(sec)</th>
			<th nowrap="nowrap" width="20%">Time Stamp</th>
			<!-- <th>Host</th> -->
		</tr>
	</xsl:template>
	
	
	<xsl:template name="testsuite.test.header.method">
		<tr valign="top">
			<th>Tests</th>
			<th>Errors</th>
			<th>Failures</th>
			<th>Successes</th>
			<th>Time(sec)</th>
		</tr>
	</xsl:template>
	
	
	

	<!-- method header -->
	<xsl:template name="testcase.test.header">
		<xsl:param name="show.class" select="''" />
		<tr valign="top">
			<xsl:if test="boolean($show.class)">
				<th>Class</th>
			</xsl:if>
			<th width="40%">Name</th>
			<th>Status</th>
			<th width="50%">Error details</th>
			<th nowrap="nowrap">Time(sec)</th>
			
	
		</tr>
	</xsl:template>


	<!-- class information -->
	<xsl:template match="testsuite" mode="print.test">
	
		<tr valign="top">
			<xsl:attribute name="class">
            <xsl:choose>
                <xsl:when test="@errors[.&gt; 0]">Error</xsl:when>
                <xsl:when test="@failures[.&gt; 0]">Failure</xsl:when>
                <xsl:otherwise>Pass</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
			<td>
				<a title="Display all tests" href="{@id}_{@name}.html">
					<xsl:value-of select="@name" />
				</a>
			</td>
			<td>
				<a title="Display all tests" href="{@id}_{@name}.html">
					<xsl:apply-templates select="@tests" />
				</a>
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="@errors != 0">
						<a title="Display only errors" href="{@id}_{@name}-errors.html">
							<xsl:apply-templates select="@errors" />
						</a>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="@errors" />
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="@failures != 0">
						<a title="Display only failures" href="{@id}_{@name}-fails.html">
							<xsl:apply-templates select="@failures" />
						</a>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="@failures" />
					</xsl:otherwise>
				</xsl:choose>
			</td>
          <td>
           <xsl:variable name="testcount" select="@tests"/>
          <xsl:variable name="errorcount" select="@errors"/>
          <xsl:variable name="failurecount" select="@failures"/>
          <xsl:variable name="successcount" select="($testcount - $errorcount - $failurecount)"/>
         
       			<xsl:choose>
					<xsl:when test="$successcount != 0">
						<a title="Display only success" href="{@id}_{@name}-success.html">
							
		       				<xsl:value-of select="$successcount"/> 
						</a>
					</xsl:when>
					<xsl:otherwise>
						 <xsl:value-of select="$successcount"/> 
					</xsl:otherwise>
				</xsl:choose>

          </td>

			<td>
				<xsl:call-template name="display-time">
					<xsl:with-param name="value" select="@time" />
				</xsl:call-template>
			</td>
			<td>
				<xsl:apply-templates select="@timestamp" />
			</td>
			
		</tr>
	</xsl:template>


	<xsl:template match="testsuite" mode="print.test.method">
		
		<xsl:param name="count" />
		<tr valign="top">
			<xsl:attribute name="class">
            <xsl:choose>
                <xsl:when test="@errors[.&gt; 0]">Error</xsl:when>
                <xsl:when test="@failures[.&gt; 0]">Failure</xsl:when>
                <xsl:otherwise>Pass</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
			<td>
				<a title="Display all tests" href="{@id}_{@name}.html">
					<xsl:apply-templates select="@tests" />
				</a>
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="@errors != 0">
						<a title="Display only errors" href="{@id}_{@name}-errors.html">
							<xsl:apply-templates select="@errors" />
						</a>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="@errors" />
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="@failures != 0">
						<a title="Display only failures" href="{@id}_{@name}-fails.html">
							<xsl:apply-templates select="@failures" />
						</a>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="@failures" />
					</xsl:otherwise>
				</xsl:choose>
			</td>

			<td>
			   
					<xsl:choose>
					<xsl:when test="$count != 0">
						<a title="Display only success" href="{@id}_{@name}-success.html">
							
		       				 <xsl:value-of select="$count" />
						</a>
					</xsl:when>
					<xsl:otherwise>
						 <xsl:value-of select="$count" />
					</xsl:otherwise>
				</xsl:choose>

		        
            </td>
            <td>
                 <xsl:call-template name="display-time">
					  <xsl:with-param name="value" select="@time" />
				</xsl:call-template>
                 
                 
            </td>
			
		</tr>
	</xsl:template>



















	<xsl:template match="testcase" mode="print.test">
		<xsl:param name="show.class" select="''" />
		<tr valign="top">
			<xsl:attribute name="class">
            <xsl:choose>
                <xsl:when test="error">Error</xsl:when>
                <xsl:when test="failure">Failure</xsl:when>
                <xsl:otherwise>TableRowColor</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
			<xsl:variable name="class.href">
				<xsl:value-of
					select="concat(translate(../@package,'.','/'), '/', ../@id, '_', ../@name, '.html')" />
			</xsl:variable>
			<xsl:if test="boolean($show.class)">
				<td>
					<a href="{$class.href}">
						<xsl:value-of select="../@name" />
					</a>
				</td>
			</xsl:if>
			<td>
				<a name="{@name}" />
				<xsl:choose>
					<xsl:when test="boolean($show.class)">
						<a href="{concat($class.href, '#', @name)}">
							<xsl:value-of select="@name" />
						</a>
						
						
					</xsl:when>
					<xsl:otherwise>
                    <xsl:variable name="method.href" select="concat(../@id, '_', ../@name,'_', @name,'.html')"/>
					
					
					<a href="{$method.href}" target="popup" 
							onclick="window.open('{$method.href}','popup','width=600,height=600,dialog=yes,menubar=no'); return false;">
						 <xsl:value-of select="@name" />
					</a>
					</xsl:otherwise>
				</xsl:choose>
			</td>
			
		
			
			
			<xsl:choose>
				<xsl:when test="failure">
					<td>Failure</td>
					
					<td id="errordetails">
					   
					    
					    <div>		    
						<div class="left" style="width:4%"> <img id="{@name}_img" class="stacktrace" src="../test/img/expand.gif"  onclick="javascript:toggle('{@name}','{@name}_img','{@name}_hide');"/> </div>   <div class="right" style="width:96%"><xsl:apply-templates select="failure"/></div>
			       		</div>			
			       		<div>
			       		<div class="hide" id="{@name}_hide" style="width:4%" name="hide">.</div> <div id="{@name}" class="stacktrace" style="width:96%"><xsl:apply-templates select="failure" mode="stacktrace"/></div>
						</div>    
							
					</td>

				</xsl:when>
				<xsl:when test="error">
					<td>Error</td>
					
					<td id="errordetails">
						             
			            <div>		    
						<div class="left" style="width:4%"> <img id="{@name}_img" class="stacktrace" src="../test/img/expand.gif"  onclick="javascript:toggle('{@name}','{@name}_img','{@name}_hide');"/> </div>   <div class="right" style="width:96%"><xsl:apply-templates select="error"/></div>
			       		</div>			
			       		<div>
			       		<div class="hide" id="{@name}_hide" style="width:4%" name="hide">.</div> <div id="{@name}" class="stacktrace" style="width:96%"> <xsl:apply-templates select="error" mode="stacktrace"/></div>
						</div> 
                         
					</td>
				</xsl:when>
				<xsl:otherwise>
					<td>Success</td>
					<td></td>
				</xsl:otherwise>
			</xsl:choose>
			<td>
				<xsl:call-template name="display-time">
					<xsl:with-param name="value" select="@time" />
				</xsl:call-template>
			</td>
			
			<xsl:choose>
					<xsl:when test="@name">
					
					<xsl:variable name="method.href" select="concat(../@id, '_', ../@name,'_', @name,'.html')"/>
					<redirect:write file="{$output.dir}/archive/{$method.href}">
			           <xsl:call-template name="method.html" />
		            </redirect:write>
					
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="@name" />
					</xsl:otherwise>
				</xsl:choose>

		</tr>
	</xsl:template>


<xsl:template match="testcase" mode="print.test.all">
		<xsl:param name="show.class" select="''" />
		<tr valign="top">
			<xsl:attribute name="class">
            <xsl:choose>
                <xsl:when test="error">Error</xsl:when>
                <xsl:when test="failure">Failure</xsl:when>
                <xsl:otherwise>TableRowColor</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
			<xsl:variable name="class.href">
				<xsl:value-of
					select="concat(../@id, '_', ../@name, '.html')" />
			</xsl:variable>
			<xsl:if test="boolean($show.class)">
				<td>
					<a href="{$class.href}">
						<xsl:value-of select="../@name" />
					</a>
				</td>
			</xsl:if>
			<td>
				<a name="{@name}" />
				<xsl:choose>
					<xsl:when test="boolean($show.class)">
						<a href="{concat($class.href, '#', @name)}">
							<xsl:value-of select="@name" />
						</a>
						
						
					</xsl:when>
					<xsl:otherwise>
					<xsl:variable name="method.href" select="concat(../@id, '_', ../@name,'_', @name,'.html')"/>
					
					
					<a href="{$method.href}" target="popup" 
							onclick="window.open('{$method.href}','popup','width=600,height=600,dialog=yes,menubar=no'); return false;">
						 <xsl:value-of select="@name" />
					</a>
					</xsl:otherwise>
				</xsl:choose>
			</td>
			
		
			
			
			<xsl:choose>
				<xsl:when test="failure">
					<td>Failure</td>
					
					<td id="errordetails">
					   
					   
					    <div>		    
						<div class="left" style="width:4%"> <img id="{@classname}_{@name}_img" class="stacktrace" src="../test/img/expand.gif"  onclick="javascript:toggle('{@classname}_{@name}','{@classname}_{@name}_img','{@classname}_{@name}_hide');"/> </div>   <div class="right" style="width:96%"><xsl:apply-templates select="failure"/></div>
			       		</div>			
			       		<div>
			       		<div class="hide" id="{@classname}_{@name}_hide" style="width:4%" name="hide">.</div> <div id="{@classname}_{@name}" class="stacktrace" style="width:96%"><xsl:apply-templates select="failure" mode="stacktrace"/></div>
						</div>    
							
					</td>

				</xsl:when>
				<xsl:when test="error">
					<td>Error</td>
					
					<td id="errordetails">
						             
			            <div>		    
						<div class="left" style="width:4%"> <img id="{@classname}_{@name}_img" class="stacktrace" src="../test/img/expand.gif"  onclick="javascript:toggle('{@classname}_{@name}','{@classname}_{@name}_img','{@classname}_{@name}_hide');"/> </div>   <div class="right" style="width:96%"><xsl:apply-templates select="error"/></div>
			       		</div>			
			       		<div>
			       		<div class="hide" id="{@classname}_{@name}_hide" style="width:4%" name="hide">.</div> <div id="{@classname}_{@name}" class="stacktrace" style="width:96%"> <xsl:apply-templates select="error" mode="stacktrace"/></div>
						</div> 
                         
					</td>
				</xsl:when>
				<xsl:otherwise>
					<td>Success</td>
					<td></td>
				</xsl:otherwise>
			</xsl:choose>
			<td>
				<xsl:call-template name="display-time">
					<xsl:with-param name="value" select="@time" />
				</xsl:call-template>
			</td>
			
			<xsl:choose>
					<xsl:when test="@name">
					<xsl:variable name="method.href" select="concat(../@id, '_', ../@name,'_', @name,'.html')"/>
					<redirect:write file="{$output.dir}/archive/{$method.href}">
			           <xsl:call-template name="method.html" />
		            </redirect:write>
					
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="@name" />
					</xsl:otherwise>
				</xsl:choose>

		</tr>
	</xsl:template>































	<!-- Note : the below template error and failure are the same style so just 
		call the same style store in the toolkit template -->
	<xsl:template match="failure">
		<xsl:call-template name="display-failures" />
		
	</xsl:template>
	
	<xsl:template match="failure" mode="stacktrace">
		
		<xsl:call-template name="display-stacktrace" />
	</xsl:template>


	<xsl:template match="error">
		<xsl:call-template name="display-failures" />
		
	</xsl:template>
	
	<xsl:template match="error" mode="stacktrace">
		
		<xsl:call-template name="display-stacktrace" />
	</xsl:template>
	


	<!-- Style for the error and failure in the testcase template -->
	<xsl:template name="display-failures">
	 <xsl:choose>
			<xsl:when test="not(@message)">
				N/A
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="@message" />
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template>
	
	<xsl:template name="display-stacktrace">
		<!-- display the stacktrace -->
		<br />
		<br />
		<code>
			<xsl:call-template name="br-replace">
				<xsl:with-param name="word" select="." />
			</xsl:call-template>
		</code>
		<!-- the latter is better but might be problematic for non-21" monitors... -->
		<!--pre><xsl:value-of select="."/></pre -->
		
	</xsl:template>
<!--  
	<xsl:template name="JS-escape">
		<xsl:param name="string" />
		<xsl:param name="tmp1"
			select="stringutils:replace(string($string),'\','\\')" />
		<xsl:param name="tmp2"
			select="stringutils:replace(string($tmp1),&quot;'&quot;,&quot;\&apos;&quot;)" />
		<xsl:value-of select="$tmp2" />
	</xsl:template> -->


	<!-- template that will convert a carriage return into a br tag @param word 
		the text from which to convert CR to BR tag -->
	<xsl:template name="br-replace">
		<xsl:param name="word" />
		<xsl:choose>
			<xsl:when test="contains($word, '&#xa;')">
				<xsl:value-of select="substring-before($word, '&#xa;')" />
				<br />
				<xsl:call-template name="br-replace">
					<xsl:with-param name="word"
						select="substring-after($word, '&#xa;')" />
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$word" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="display-time">
		<xsl:param name="value" />
		<xsl:value-of select="format-number($value,'0.000')" />
	</xsl:template>

	<xsl:template name="display-percent">
		<xsl:param name="value" />
		<xsl:value-of select="format-number($value,'0.00%')" />
	</xsl:template>
</xsl:stylesheet>
