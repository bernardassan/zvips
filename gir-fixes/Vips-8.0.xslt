<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:core="http://www.gtk.org/introspection/core/1.0"
    xmlns:c="http://www.gtk.org/introspection/c/1.0"
    xmlns:doc="http://www.gtk.org/introspection/doc/1.0"
    xmlns:glib="http://www.gtk.org/introspection/glib/1.0">

  <!-- Identity transform (copies nodes and attributes as-is by default unless a more specific template overrides them) -->
    <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()" />
    </xsl:copy>
  </xsl:template>

  <!-- Match the last <include> element and insert <package> after it -->
  <xsl:template match="core:include[last()]">
    <!-- Copy the matched <include> element AND all it children/attributes -->
    <xsl:copy-of select="."/>
    <xsl:element name="package" namespace="http://www.gtk.org/introspection/core/1.0">
      <xsl:attribute name="name">vips</xsl:attribute>
    </xsl:element>
  </xsl:template>

  <!-- Replace type of `RegionType` field with a c_int since it is a private
       enum in libvips https://github.com/libvips/libvips/blob/d003027b5a1e6a32cbb55560c751cbc05ddc9b57/libvips/include/vips/private.h#L144-L152
       and C enums are ints at the abi level -->
  <xsl:template match="core:class[@name='Region']/core:field[@name='type']/core:type">
    <xsl:copy>
      <xsl:attribute name="name">gint</xsl:attribute>
      <xsl:attribute name="c:type">gint</xsl:attribute>
    </xsl:copy>
  </xsl:template>

  <!-- make the return type of Image.newFromFile nullable -->
  <xsl:template match="core:class[@name='Image']/core:constructor[@c:identifier='vips_image_new_from_file']/core:return-value">
    <xsl:copy>
      <xsl:attribute name="nullable">1</xsl:attribute>
      <xsl:copy-of select="@* | node()" />
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
