<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:template name="fields-for-page">
    <xsl:param name="page" />

    <xsl:for-each select="//Fields/Field[@Page=$page]">
      <dl>
        <dt>
          <label for="page-{$page}-field-{position()}">
            <xsl:value-of select="@FieldName" />
            <xsl:text>:</xsl:text>
          </label>
        </dt>
        <dd>
          <xsl:choose>
            <xsl:when test="@Multiline">
              <textarea id="page-{$page}-field-{position()}" name="zetaprints-_{@FieldName}">
                <xsl:if test="string-length(@Hint)!=0">
                  <xsl:attribute name="title"><xsl:value-of select="@Hint" /></xsl:attribute>
                </xsl:if>
                <xsl:choose>
                  <xsl:when test="@Value and string-length(@Value)!=0">
                    <xsl:value-of select="@Value" />
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:text>&#x0A;</xsl:text>
                  </xsl:otherwise>
                </xsl:choose>
              </textarea>
            </xsl:when>
            <xsl:otherwise>
              <xsl:choose>
                <xsl:when test="count(Value)=0">
                  <input type="text" id="page-{$page}-field-{position()}" name="zetaprints-_{@FieldName}" class="input-text">
                    <xsl:if test="@MaxLen">
                      <xsl:attribute name="maxlength"><xsl:value-of select="@MaxLen" /></xsl:attribute>
                    </xsl:if>
                    <xsl:if test="string-length(@Hint)!=0">
                      <xsl:attribute name="title"><xsl:value-of select="@Hint" /></xsl:attribute>
                    </xsl:if>
                    <xsl:if test="@Value">
                      <xsl:attribute name="value"><xsl:value-of select="@Value" /></xsl:attribute>
                    </xsl:if>
                  </input>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:choose>
                    <xsl:when test="count(Value)=2 and string-length(Value[last()])=0">
                      <input type="hidden" name="zetaprints-_{@FieldName}" value="&#x2E0F;" />
                      <input id="page-{$page}-field-{position()}" type="checkbox" name="zetaprints-_{@FieldName}" value="{Value[1]}" title="{@Hint}">
                        <xsl:if test="@Value=Value[1]">
                          <xsl:attribute name="checked">1</xsl:attribute>
                        </xsl:if>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <select id="page-{$page}-field-{position()}" name="zetaprints-_{@FieldName}" title="{@Hint}">
                        <xsl:for-each select="Value">
                          <option>
                            <xsl:if test=".=../@Value">
                              <xsl:attribute name="selected">1</xsl:attribute>
                            </xsl:if>
                            <xsl:value-of select="." />
                          </option>
                        </xsl:for-each>
                      </select>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:otherwise>
          </xsl:choose>
        </dd>
      </dl>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="stock-images-for-page">
    <xsl:param name="page" />

    <xsl:for-each select="//Images/Image[@Page=$page]">
      <div class="zetaprints-images-selector no-value minimized block">
        <div class="head block-title">
          <a class="image up-down" href="#"><span>Up/Down</span></a>
          <a class="image collapse-expand" href="#"><span>Collapse/Expand</span></a>
          <div class="icon"><span>Title: </span></div>
          <div class="title">
            <label><xsl:value-of select="@Name" /></label>
          </div>
        </div>
        <div id="page-{$page}-tabs-{position()}" class="selector-content">
          <ul class="tab-buttons">
            <xsl:if test="@AllowUpload='1'">
              <li>
                <div class="icon upload"><span>Upload</span></div>
                <a href="#page-{$page}-tabs-{position()}-1"><span>Upload</span></a>
              </li>
              <li class="hidden">
                <div class="icon user-images"><span>My images</span></div>
                <a href="#page-{$page}-tabs-{position()}-2"><span>My images</span></a>
              </li>
            </xsl:if>
            <xsl:if test="StockImage">
              <li>
                <div class="icon stock-images"><span>Stock images</span></div>
                <a href="#page-{$page}-tabs-{position()}-3"><span>Stock images</span></a>
              </li>
            </xsl:if>
            <xsl:if test="@ColourPicker='RGB'">
              <li>
                <div class="icon color-picker"><span>Color picker</span></div>
                <a href="#page-{$page}-tabs-{position()}-4"><span>Color picker</span></a>
              </li>
            </xsl:if>
            <li class="last"><label><input type="radio" name="zetaprints-#{@Name}" value="" /> Leave blank</label></li>
          </ul>
          <div class="tabs-wrapper">
          <xsl:if test="@AllowUpload='1'">
            <div id="page-{$page}-tabs-{position()}-1" class="tab upload">
              <div class="column">
                <input type="text" class="input-text file-name" disabled="true" />
                <label>Upload new image from your computer</label>
              </div>

              <div class="column">
                <div class="button choose-file"><span>Choose file</span></div>
                <div class="button upload-file disabled"><span>Upload file</span></div>
                <img class="ajax-loader" src="{$ajax-loader-image-url}" />
              </div>

              <!--<div class="clear"><span>&#x0A;</span></div>-->
            </div>
            <div id="page-{$page}-tabs-{position()}-2" class="tab user-images images-scroller">
              <input type="hidden" name="parameter" value="{@Name}" />
              <table><tr>
                <xsl:for-each select="user-image">
                  <td>
                    <input type="radio" name="zetaprints-#{../@Name}" value="{@guid}">
                      <xsl:if test="@guid=../@Value">
                        <xsl:attribute name="checked">1</xsl:attribute>
                      </xsl:if>
                    </input>
                    <a class="edit-dialog" href="{@edit-link}" title="Click to edit" target="_blank">
                      <img src="{@thumbnail}" />
                      <img class="edit-button" src="{$user-image-edit-button}" />
                    </a>
                  </td>
                </xsl:for-each>
              </tr></table>
            </div>
          </xsl:if>
          <xsl:if test="StockImage">
            <div id="page-{$page}-tabs-{position()}-3" class="tab images-scroller">
              <table><tr>
                <xsl:for-each select="StockImage">
                  <td>
                    <input type="radio" name="zetaprints-#{../@Name}" value="{@FileID}">
                      <xsl:if test="@FileID=../@Value">
                        <xsl:attribute name="checked">1</xsl:attribute>
                      </xsl:if>
                    </input>
                    <a class="in-dialog" href="{$zetaprints-api-url}photothumbs/{@Thumb}" title="Click to enlarge" target="_blank" rel="group-{../@Name}">
                      <xsl:choose>
                        <xsl:when test="contains(@Thumb, '.png') or contains(@Thumb, '.gif')">
                          <img src="{$zetaprints-api-url}photothumbs/{@Thumb}" />
                        </xsl:when>
                        <xsl:otherwise>
                          <img src="{$zetaprints-api-url}photothumbs/{substring-before(@Thumb,'.')}_0x100.{substring-after(@Thumb,'.')}" />
                        </xsl:otherwise>
                      </xsl:choose>
                    </a>
                  </td>
                </xsl:for-each>
              </tr></table>
            </div>
          </xsl:if>

          <xsl:if test="@ColourPicker='RGB'">
            <div id="page-{$page}-tabs-{position()}-4" class="tab color-picker">
              <input type="radio" name="zetaprints-#{@Name}">
                <xsl:choose>
                  <xsl:when test="string-length(@Value)=7 and starts-with(@Value,'#')">
                    <xsl:attribute name="value"><xsl:value-of select="@Value" /></xsl:attribute>
                    <xsl:attribute name="checked">1</xsl:attribute>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:attribute name="value"></xsl:attribute>
                    <xsl:attribute name="disabled">1</xsl:attribute>
                  </xsl:otherwise>
                </xsl:choose>
              </input>
              <div class="color-sample"><span>&#x0A;</span></div>
              <span><a href="#">Choose a color</a> and click Select to fill the place of the photo.</span>
            </div>
          </xsl:if>
          </div>

          <!--<div class="clear">&#x0A;</div>-->
        </div>
      </div>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="image-tabs-for-pages">
    <div class="zetaprints-image-tabs">
      <ul style="width: {count(Page) * 135}px;">
      <xsl:for-each select="Page">
          <li title="Click to show page">
            <img rel="page-{position()}" src="{$zetaprints-api-url}{substring-before(@ThumbImage, '.')}_100x100.{substring-after(@ThumbImage, '.')}" />
            <br />
            <span><xsl:value-of select="@Name" /></span>
          </li>
        </xsl:for-each>
      </ul>
    </div>
  </xsl:template>
</xsl:stylesheet>