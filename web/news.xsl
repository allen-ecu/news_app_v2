<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="/">
  <html>
  <body>
    <table border="1">
      <tr bgcolor="#9acd32">
        <th>Title</th>
        <th>Description</th>
        <th>Photo</th>
       <th>Time</th>
       <th>IP</th>
      </tr>
      <xsl:for-each select="news/item">
      <tr>
        <td><xsl:value-of select="title"/></td>
        <td><xsl:value-of select="description"/></td>
        <td><xsl:value-of select="photo"/></td>
        <td><xsl:value-of select="time"/></td>
        <td><xsl:value-of select="ip"/></td>
      </tr>
      </xsl:for-each>
    </table>
  </body>
  </html>
</xsl:template>
</xsl:stylesheet>

