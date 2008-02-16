<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE xsl:stylesheet [<!ENTITY nbsp "&#160;">]>

<!--
  ++ Automated Testing Framework (atf)
  ++
  ++ Copyright (c) 2007 The NetBSD Foundation, Inc.
  ++ All rights reserved.
  ++
  ++ Redistribution and use in source and binary forms, with or without
  ++ modification, are permitted provided that the following conditions
  ++ are met:
  ++ 1. Redistributions of source code must retain the above copyright
  ++    notice, this list of conditions and the following disclaimer.
  ++ 2. Redistributions in binary form must reproduce the above copyright
  ++    notice, this list of conditions and the following disclaimer in the
  ++    documentation and/or other materials provided with the distribution.
  ++ 3. All advertising materials mentioning features or use of this
  ++    software must display the following acknowledgement:
  ++        This product includes software developed by the NetBSD
  ++        Foundation, Inc. and its contributors.
  ++ 4. Neither the name of The NetBSD Foundation nor the names of its
  ++    contributors may be used to endorse or promote products derived
  ++    from this software without specific prior written permission.
  ++
  ++ THIS SOFTWARE IS PROVIDED BY THE NETBSD FOUNDATION, INC. AND
  ++ CONTRIBUTORS ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES,
  ++ INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
  ++ MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
  ++ IN NO EVENT SHALL THE FOUNDATION OR CONTRIBUTORS BE LIABLE FOR ANY
  ++ DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
  ++ DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
  ++ GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
  ++ INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER
  ++ IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
  ++ OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
  ++ IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  -->

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Parameters that can be overriden by the user. -->
  <xsl:param name="global.css">tests-results.css</xsl:param>
  <xsl:param name="global.title">ATF Tests Results</xsl:param>

  <xsl:variable name="ntps"
                select="count(tests-results/tp)" />
  <xsl:variable name="ntps-failed"
                select="count(tests-results/tp/failed)" />
  <xsl:variable name="ntcs"
                select="count(tests-results/tp/tc)" />
  <xsl:variable name="ntcs-passed"
                select="count(tests-results/tp/tc/passed)" />
  <xsl:variable name="ntcs-failed"
                select="count(tests-results/tp/tc/failed)" />
  <xsl:variable name="ntcs-skipped"
                select="count(tests-results/tp/tc/skipped)" />

  <xsl:template match="/">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="tests-results">
    <html xmlns="http://www.w3.org/1999/xhtml">
      <head>
        <meta http-equiv="Content-Type"
              content="text/html; charset=iso-8859-1" />
        <link rel="stylesheet" type="text/css" href="{$global.css}" />

        <title><xsl:value-of select="$global.title" /></title>
      </head>

      <body>
        <h1><xsl:value-of select="$global.title" /></h1>

        <xsl:call-template name="info-top" />
        <xsl:call-template name="tcs-summary" />
        <xsl:if test="$ntcs-failed > 0">
          <xsl:call-template name="failed-tcs-summary" />
        </xsl:if>
        <xsl:if test="$ntcs-skipped > 0">
          <xsl:call-template name="skipped-tcs-summary" />
        </xsl:if>
        <xsl:call-template name="info-bottom" />

        <xsl:apply-templates select="tp" mode="details" />
      </body>
    </html>
  </xsl:template>

  <xsl:template name="info-top">
    <h2>Execution summary</h2>

    <table class="summary">
      <tr>
        <th><p>Item</p></th>
        <th><p>Value</p></th>
      </tr>

      <tr class="group">
        <td colspan="2"><p>ATF</p></td>
      </tr>
      <tr class="entry">
        <td><p>Version</p></td>
        <td><p><xsl:apply-templates
        select="info[@class = 'atf.version']" /></p></td>
      </tr>

      <tr class="group">
        <td colspan="2"><p>Timings</p></td>
      </tr>
      <tr class="entry">
        <td><p>Start time of tests</p></td>
        <td><p><xsl:apply-templates
        select="info[@class = 'time.start']" /></p></td>
      </tr>
      <tr class="entry">
        <td><p>End time of tests</p></td>
        <td><p><xsl:apply-templates
        select="info[@class = 'time.end']" /></p></td>
      </tr>

      <tr class="group">
        <td colspan="2"><p>System information</p></td>
      </tr>
      <tr class="entry">
        <td><p>Host name</p></td>
        <td><p><xsl:apply-templates
        select="info[@class = 'uname.nodename']" /></p></td>
      </tr>
      <tr class="entry">
        <td><p>Operating system</p></td>
        <td><p><xsl:apply-templates
        select="info[@class = 'uname.sysname']" /></p></td>
      </tr>
      <tr class="entry">
        <td><p>Operating system release</p></td>
        <td><p><xsl:apply-templates
        select="info[@class = 'uname.release']" /></p></td>
      </tr>
      <tr class="entry">
        <td><p>Operating system version</p></td>
        <td><p><xsl:apply-templates
        select="info[@class = 'uname.version']" /></p></td>
      </tr>
      <tr class="entry">
        <td><p>Platform</p></td>
        <td><p><xsl:apply-templates
        select="info[@class = 'uname.machine']" /></p></td>
      </tr>

      <tr class="group">
        <td colspan="2"><p>Tests results</p></td>
      </tr>
      <tr class="entry">
        <td><p>Root</p></td>
        <td><p><xsl:value-of
        select="info[@class = 'tests.dir']" /></p></td>
      </tr>
      <tr class="entry">
        <td><p>Test programs</p></td>
        <td class="numeric"><p><xsl:value-of select="$ntps" /></p></td>
      </tr>
      <tr class="entry">
        <td><p>Bogus test programs</p></td>
        <xsl:choose>
          <xsl:when test="$ntps-failed > 0">
            <td class="numeric-error">
              <p><xsl:value-of select="$ntps-failed" /></p>
            </td>
          </xsl:when>
          <xsl:otherwise>
            <td class="numeric">
              <p><xsl:value-of select="$ntps-failed" /></p>
            </td>
          </xsl:otherwise>
        </xsl:choose>
      </tr>
      <tr class="entry">
        <td><p>Test cases</p></td>
        <td class="numeric"><p><xsl:value-of select="$ntcs" /></p></td>
      </tr>
      <tr class="entry">
        <td><p>Passed test cases</p></td>
        <td class="numeric"><p><xsl:value-of select="$ntcs-passed" /></p></td>
      </tr>
      <tr class="entry">
        <xsl:choose>
          <xsl:when test="$ntcs-failed > 0">
            <td><p><a href="#failed-tcs-summary">Failed test
            cases</a></p></td>
            <td class="numeric-error">
              <p><xsl:value-of select="$ntcs-failed" /></p>
            </td>
          </xsl:when>
          <xsl:otherwise>
            <td><p>Failed test cases</p></td>
            <td class="numeric">
              <p><xsl:value-of select="$ntcs-failed" /></p>
            </td>
          </xsl:otherwise>
        </xsl:choose>
      </tr>
      <tr class="entry">
        <xsl:choose>
          <xsl:when test="$ntcs-skipped > 0">
            <td><p><a href="#skipped-tcs-summary">Skipped test
            cases</a></p></td>
            <td class="numeric-warning">
              <p><xsl:value-of select="$ntcs-skipped" /></p>
            </td>
          </xsl:when>
          <xsl:otherwise>
            <td><p>Skipped test cases</p></td>
            <td class="numeric">
              <p><xsl:value-of select="$ntcs-skipped" /></p>
            </td>
          </xsl:otherwise>
        </xsl:choose>
      </tr>

      <tr class="group">
        <td colspan="2"><p><a href="#execution-details">See more execution
        details</a></p></td>
      </tr>
    </table>
  </xsl:template>

  <xsl:template name="info-bottom">
    <a name="execution-details" />
    <h2 id="execution-details">Execution details</h2>

    <h3>Environment variables</h3>

    <ul>
      <xsl:apply-templates select="info[@class = 'env']">
        <xsl:sort />
      </xsl:apply-templates>
    </ul>
  </xsl:template>

  <xsl:template match="info[@class = 'env']">
    <li>
      <p><xsl:apply-templates /></p>
    </li>
  </xsl:template>

  <xsl:template name="tcs-summary">
    <h2>Test cases summary</h2>

    <table class="tcs-summary">
      <tr>
        <th><p>Test case</p></th>
        <th><p>Result</p></th>
        <th><p>Reason</p></th>
      </tr>
      <xsl:apply-templates select="tp" mode="summary">
        <xsl:with-param name="which">all</xsl:with-param>
      </xsl:apply-templates>
    </table>
  </xsl:template>

  <xsl:template name="failed-tcs-summary">
    <a name="failed-tcs-summary" />
    <h2 id="failed-tcs-summary">Failed test cases summary</h2>

    <table class="tcs-summary">
      <tr>
        <th><p>Test case</p></th>
        <th><p>Result</p></th>
        <th><p>Reason</p></th>
      </tr>
      <xsl:apply-templates select="tp" mode="summary">
        <xsl:with-param name="which">failed</xsl:with-param>
      </xsl:apply-templates>
    </table>
  </xsl:template>

  <xsl:template name="skipped-tcs-summary">
    <a name="skipped-tcs-summary" />
    <h2 id="skipped-tcs-summary">Skipped test cases summary</h2>

    <table class="tcs-summary">
      <tr>
        <th><p>Test case</p></th>
        <th><p>Result</p></th>
        <th><p>Reason</p></th>
      </tr>
      <xsl:apply-templates select="tp" mode="summary">
        <xsl:with-param name="which">skipped</xsl:with-param>
      </xsl:apply-templates>
    </table>
  </xsl:template>

  <xsl:template match="tp" mode="summary">
    <xsl:param name="which" />

    <xsl:variable name="chosen">
      <xsl:choose>
        <xsl:when test="$which = 'passed' and tc/passed">yes</xsl:when>
        <xsl:when test="$which = 'failed' and tc/failed">yes</xsl:when>
        <xsl:when test="$which = 'skipped' and tc/skipped">yes</xsl:when>
        <xsl:when test="$which = 'all'">yes</xsl:when>
        <xsl:otherwise>no</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:if test="$chosen = 'yes'">
      <tr>
        <td class="tp-id" colspan="3">
          <p><xsl:value-of select="@id" /></p>
        </td>
      </tr>
      <xsl:apply-templates select="tc" mode="summary">
        <xsl:with-param name="which" select="$which" />
      </xsl:apply-templates>
    </xsl:if>
  </xsl:template>

  <xsl:template match="tc" mode="summary">
    <xsl:param name="which" />

    <xsl:variable name="full-id"
                  select="concat(translate(../@id, '/', '_'), '_', @id)" />

    <xsl:variable name="chosen">
      <xsl:choose>
        <xsl:when test="$which = 'passed' and ./passed">yes</xsl:when>
        <xsl:when test="$which = 'failed' and ./failed">yes</xsl:when>
        <xsl:when test="$which = 'skipped' and ./skipped">yes</xsl:when>
        <xsl:when test="$which = 'all'">yes</xsl:when>
        <xsl:otherwise>no</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:if test="$chosen = 'yes'">
      <tr>
        <td class="tc-id">
          <xsl:choose>
            <xsl:when test="failed|skipped">
              <p><a href="#{$full-id}"><xsl:value-of select="@id" /></a></p>
            </xsl:when>
            <xsl:otherwise>
              <p><xsl:value-of select="@id" /></p>
            </xsl:otherwise>
          </xsl:choose>
        </td>
        <xsl:apply-templates select="passed|failed|skipped" mode="tc" />
      </tr>
    </xsl:if>
  </xsl:template>

  <xsl:template match="passed" mode="tc">
    <td class="tcr-passed"><p>Passed</p></td>
    <td><p>N/A</p></td>
  </xsl:template>

  <xsl:template match="failed" mode="tc">
    <td class="tcr-failed"><p>Failed</p></td>
    <td><p><xsl:apply-templates /></p></td>
  </xsl:template>

  <xsl:template match="skipped" mode="tc">
    <td class="tcr-skipped"><p>Skipped</p></td>
    <td><p><xsl:apply-templates /></p></td>
  </xsl:template>

  <xsl:template match="tp" mode="details">
    <xsl:apply-templates select="tc[failed|skipped]" mode="details" />
  </xsl:template>

  <xsl:template match="failed" mode="details">
    <p class="term"><strong>FAILED</strong>: <xsl:apply-templates /></p>
  </xsl:template>

  <xsl:template match="skipped" mode="details">
    <p class="term"><strong>SKIPPED</strong>: <xsl:apply-templates /></p>
  </xsl:template>

  <xsl:template match="tc" mode="details">
    <xsl:variable name="full-id"
                  select="concat(translate(../@id, '/', '_'), '_', @id)" />

    <a name="{$full-id}" />
    <h2 id="{$full-id}">Test case:
    <xsl:value-of select="../@id" /><xsl:text>/</xsl:text>
    <xsl:value-of select="@id" /></h2>

    <h3>Termination reason</h3>
    <xsl:apply-templates select="failed|skipped" mode="details" />

    <xsl:if test="so">
      <h3>Standard output stream</h3>
      <pre class="so"><xsl:apply-templates select="so" mode="details" /></pre>
    </xsl:if>

    <xsl:if test="se">
      <h3>Standard error stream</h3>
      <pre class="se"><xsl:apply-templates select="se" mode="details" /></pre>
    </xsl:if>
  </xsl:template>

  <xsl:template match="so" mode="details">
    <xsl:apply-templates />
    <xsl:if test="position() != last()">
      <xsl:text>
</xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template match="se" mode="details">
    <xsl:apply-templates />
    <xsl:if test="position() != last()">
      <xsl:text>
</xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template match="@*|node()" priority="-1">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>