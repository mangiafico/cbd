<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:akn="http://docs.oasis-open.org/legaldocml/ns/akn/3.0"
	xmlns:un="http://www.informea.org/"
	xmlns="http://www.w3.org/1999/xhtml"
	exclude-result-prefixes="akn">

<xsl:output method="html" encoding="utf-8" />

<xsl:template match="akn:akomaNtoso">
	<html>
		<xsl:apply-templates/>
	</html>
</xsl:template>

<xsl:template match="akn:doc">
	<head>
		<title>Convention on Biological Diversity</title>
		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-alpha.6/css/bootstrap.min.css"/>
		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css"/>
		<link rel="stylesheet" href="cbd.css" type="text/css"/>
	</head>
	<body>
		<xsl:apply-templates/>
		<script src="https://code.jquery.com/jquery-3.1.1.slim.min.js"></script>
		<script src="https://cdnjs.cloudflare.com/ajax/libs/tether/1.4.0/js/tether.min.js"></script>
		<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-alpha.6/js/bootstrap.min.js"></script>
		<script>
		var goalURLs = [];
 		<xsl:for-each select="/akn:akomaNtoso/akn:doc/akn:meta/akn:references/akn:TLCConcept[starts-with(@eId,'sdg-goal-')]">
	 		<xsl:variable name="num" select="substring(@eId, 10)" />
	 		<xsl:text>goalURLs[</xsl:text>
	 		<xsl:value-of select="$num"/>
	 		<xsl:text>] = '</xsl:text>
			<xsl:value-of select="@href"/>
	 		<xsl:text>';
</xsl:text>
 		</xsl:for-each>
		$('.fa-trophy').popover({ placement: 'top', trigger: 'focus', title: 'SDG Goals', html: true, content: function() {
			var numbers = this.getAttribute('data-goals').split(', ');
			var links = numbers.map(function(number) { return '<a target="_blank" href="' + goalURLs[parseInt(number)] + '">' + number + '</a>' });
			return links.join(', ');
		} });
		$('.fa-bullseye').popover({ placement: 'top', trigger: 'focus', title: 'SDG Targets', html: true, content: function() {
			var numbers = this.getAttribute('data-targets').split(', ');
			var links = numbers.map(function(number) { return '<a target="_blank" href="https://www.informea.org/en/goal/' + number.replace('.','') + '">' + number + '</a>' });
			return links.join(', ');
		} });
		$('.fa-tags').popover({ placement: 'top', trigger: 'focus', title: 'LEO Terms', html: true, content: function() {
			var tags = this.getAttribute('data-tags').split(', ');
			var links = tags.map(function(tag) { return '<a target="_blank" href="http://www.informea.org/terms/' + tag.toLowerCase().replace(/ /g,'-') + '/">' + tag + '</a>' });
			return links.join(', ');
		} });
		</script>
	</body>
</xsl:template>

<xsl:template match="akn:meta"/>

<xsl:template match="akn:preamble">
	<div role="preamble">
		<xsl:apply-templates/>
	</div>
</xsl:template>

<xsl:template name="goals">
	<xsl:variable name="eid" select="concat('#', @eId)" />
	<xsl:variable name="goals" select="/akn:akomaNtoso/akn:doc/akn:meta/akn:analysis/akn:otherAnalysis/un:sdgGoal[@href=$eid]" />
	<xsl:if test="$goals">
		<xsl:text> </xsl:text>
		<a class="fa fa-trophy" tabindex="0">
			<xsl:attribute name="data-goals">
				<xsl:for-each select="$goals">
					<xsl:if test="position() &gt; 1">
						<xsl:text>, </xsl:text>
					</xsl:if>
					<xsl:value-of select="substring(@refersTo, 11)" />
				</xsl:for-each>
			</xsl:attribute>
		</a>
	</xsl:if>
</xsl:template>

<xsl:template name="targets">
	<xsl:variable name="eid" select="concat('#', @eId)" />
	<xsl:variable name="targets" select="/akn:akomaNtoso/akn:doc/akn:meta/akn:analysis/akn:otherAnalysis/un:sdgTarget[@href=$eid]" />
	<xsl:if test="$targets">
		<xsl:text> </xsl:text>
		<a class="fa fa-bullseye" tabindex="0">
			<xsl:attribute name="data-targets">
				<xsl:for-each select="$targets">
					<xsl:if test="position() &gt; 1">
						<xsl:text>, </xsl:text>
					</xsl:if>
					<xsl:value-of select="substring(@refersTo, 13)" />
				</xsl:for-each>
			</xsl:attribute>
		</a>
	</xsl:if>
</xsl:template>

<xsl:template name="tags">
	<xsl:variable name="eid" select="concat('#', @eId)" />
	<xsl:variable name="tags" select="/akn:akomaNtoso/akn:doc/akn:meta/akn:analysis/akn:otherAnalysis/un:leoTerm[@href=$eid]" />
	<xsl:if test="$tags">
		<xsl:text> </xsl:text>
		<a class="fa fa-tags" tabindex="0">
			<xsl:attribute name="data-tags">
				<xsl:for-each select="$tags">
					<xsl:if test="position() &gt; 1">
						<xsl:text>, </xsl:text>
					</xsl:if>
					<xsl:value-of select="/akn:akomaNtoso/akn:doc/akn:meta/akn:references/akn:TLCTerm[@eId=substring(current()/@refersTo,2)]/@showAs" />
				</xsl:for-each>
			</xsl:attribute>
		</a>
	</xsl:if>
</xsl:template>

<xsl:template match="akn:part">
	<section role="part">
		<xsl:apply-templates select="@*"/>
		<h2 role="num">
			<xsl:apply-templates select="akn:num"/>
		</h2>
		<h2 role="heading">
			<xsl:apply-templates select="akn:heading"/>
		</h2>
		<xsl:apply-templates select="*[not(self::akn:num)][not(self::akn:heading)]"/>
	</section>
</xsl:template>

<xsl:template match="akn:article">
	<section role="article">
		<xsl:apply-templates select="@*"/>
		<h2>
			<xsl:apply-templates select="akn:num"/>
			<xsl:if test="akn:num and akn:heading">
				<xsl:text> </xsl:text>
			</xsl:if>
			<xsl:apply-templates select="akn:heading"/>
			<xsl:call-template name="goals" />
			<xsl:call-template name="targets" />
			<xsl:call-template name="tags" />
		</h2>
		<xsl:apply-templates select="*[not(self::akn:num)][not(self::akn:heading)]"/>
	</section>
</xsl:template>

<xsl:template match="akn:paragraph | akn:subparagraph">
	<section role="{local-name()}">
		<xsl:apply-templates select="@*"/>
		<xsl:apply-templates/>
	</section>
</xsl:template>

<xsl:template match="akn:attachment">
	<section role="annex">
		<h2 role="num">
			<xsl:apply-templates select="akn:num"/>
		</h2>
		<xsl:if test="akn:heading">
			<h2 role="heading">
				<xsl:apply-templates select="akn:heading"/>
			</h2>
		</xsl:if>
		<xsl:apply-templates select="akn:doc/akn:mainBody"/>
	</section>
</xsl:template>


<xsl:template match="akn:num | akn:heading">
	<span role="{local-name()}">
		<xsl:apply-templates/>
	</span>
</xsl:template>

<xsl:template match="akn:intro | akn:content">
	<xsl:apply-templates/>
</xsl:template>


<xsl:template match="akn:listIntroduction">
	<p>
		<xsl:apply-templates select="@*"/>
		<xsl:apply-templates/>
	</p>
</xsl:template>

<xsl:template match="akn:p">
	<p>
		<xsl:apply-templates select="@*"/>
		<xsl:if test="parent::akn:item">
			<xsl:apply-templates select="parent::akn:item/@eId" />
			<xsl:attribute name="class">
				<xsl:text>list-item</xsl:text>
			</xsl:attribute>
		</xsl:if>
		<xsl:apply-templates/>
		<xsl:call-template name="tags" />
		<xsl:for-each select="parent::akn:item">
			<xsl:call-template name="tags" />
	   </xsl:for-each>
	   <xsl:if test="parent::akn:content and (../parent::akn:paragraph or ../parent::akn:subparagraph) and not(preceding-sibling::akn:p)">
			<xsl:for-each select="../parent::akn:*">
				<xsl:call-template name="goals" />
				<xsl:call-template name="targets" />
				<xsl:call-template name="tags" />
		   </xsl:for-each>
	   </xsl:if>
	</p>
</xsl:template>

<xsl:template match="akn:i">
	<i>
		<xsl:apply-templates/>
	</i>
</xsl:template>

<xsl:template match="akn:ref">
	<a>
		<xsl:apply-templates select="@*"/>
		<xsl:apply-templates/>
	</a>
</xsl:template>

<xsl:template match="akn:docTitle">
	<span role="docTitle">
		<xsl:apply-templates/>
	</span>
</xsl:template>

<xsl:template match="akn:def/akn:term">
	<i>
		<xsl:apply-templates/>
	</i>
</xsl:template>

<xsl:template match="@eId">
	<xsl:attribute name="id">
		<xsl:apply-templates/>
	</xsl:attribute>
</xsl:template>

<xsl:template match="@class | @style | @href">
	<xsl:copy/>
</xsl:template>

</xsl:stylesheet>
