{* 
TestLink Open Source Project - http://testlink.sourceforge.net/
tcEditViewer.inc.tpl
Purpose: smarty template - create new testcase

@internal revisions
 
*}

{* ---------------------------------------------------------------- *}
{lang_get var='labels' 
          s='tc_title,alt_add_tc_name,summary,steps,expected_results,
             preconditions,status,estimated_execution_duration,importance,
             execution_type,test_importance,tc_keywords,assign_requirements'}

{* Steps and results Layout management *}
{$layout1="<br />"}
{$layout2="<br />"}
{$layout3="<br />"}

{if $gsmarty_spec_cfg->steps_results_layout == 'horizontal'}
  {$layout1='<br /><table width="100%"><tr><td width="50%">'}
  {$layout2='</td><td width="50%">'}
  {$layout3="</td></tr></table><br />"}
{/if}
{* ---------------------------------------------------------------- *}
  <p />
  <div class="labelHolder"><label for="testcase_name">{$labels.tc_title}</label></div>
  <div> 
    <input required 
      type="text" name="testcase_name" id="testcase_name"
      size="{#TESTCASE_NAME_SIZE#}" required 
      maxlength="{#TESTCASE_NAME_MAXLEN#}"
      onchange="content_modified = true"
      onkeypress="content_modified = true"
      onkeyup="javascript:checkTCaseDuplicateName(Ext.get('testcase_id').getValue(),Ext.get('testcase_name').getValue(),
                                                  Ext.get('testsuite_id').getValue(),'testcase_name_warning')"
      {if isset($gui->tc.name)}
        value="{$gui->tc.name|escape}"
      {else}
        value=""
      {/if}
      title="{$labels.alt_add_tc_name}"/>
      <span id="testcase_name_warning" class="warning"></span>
    <p />

    {if $gui->cf.after_title neq ''}
      <div> 
        <div id="cf_after_title"
             class="custom_field_container">
          {$gui->cf.after_title}
        </div>
      </div>
        
    {/if}

    <br />

    <div id="mainAttrContainer" class="mainAttrContainer"> 
      <div id="summaryCONTAINER">
        {if $gui->cf.before_summary neq ""}
          <div id="cf_before_summary"
               class="custom_field_container">
               {$gui->cf.before_summary}
          </div>
          <br> 
        {/if}

        <div class="labelHolder">{$labels.summary}</div>
        <div>{$summary}</div>

        {if $gui->cf.after_summary neq ""}
          <div id="cf_after_summary"
               class="custom_field_container">
               {$gui->cf.after_summary}
          </div>
        {/if}

      </div>
      <div id="spaceOne" style="margin-top:35px;"></div>
      <div id="preconditionsCONTAINER">
        {if $gui->cf.before_preconditions neq ""}
          <div id="cf_before_preconditions"
               class="custom_field_container">
               {$gui->cf.before_preconditions}
          </div>
          <br> 
        {/if}

        <div class="labelHolder">{$labels.preconditions}</div>
        <div>{$preconditions}</div>
        {if $gui->cf.after_preconditions neq ""}
          <div id="cf_after_preconditions"
               class="custom_field_container">
               {$gui->cf.after_preconditions}
          </div>
        {/if}
      </div>
    </div>


    {*
    <div class="labelHolder">{$labels.summary}</div>
    <div>{$summary}</div>
    <br />

    <div class="labelHolder">{$labels.preconditions}</div>
    <div>{$preconditions}</div>
    *}


    {* Custom fields - with before steps & results location *}
    <br />
    {if $gui->cf.before_steps_results neq ""}
         <br/>
         {* ID is important because is used on validationForm to get custom field container
            that's how have to have SAME ID that other div below on page.
            NOTICE that only one of this div are active, if will not be the case we will
            have a problem because ID has to be UNIQUE
          *}
         <div id="cfields_design_time" class="custom_field_container">
         {$gui->cf.before_steps_results}
         </div>
         
    {/if}
    {$layout1}
    {include file="attributesLinear.inc.tpl"}
  </div>


  {* Custom fields - with standard location  *}
  {if $gui->cf.standard_location neq ""}
    <br/>
    <div id="cfields_design_time" class="custom_field_container">
    {$gui->cf.standard_location}
    </div>
  {/if}

  <br />
  <div>
  {$kwView = $gsmarty_href_keywordsView|replace:'%s%':$gui->tproject_id}
  <a href={$kwView}>{$labels.tc_keywords}</a>
  {include file="opt_transfer.inc.tpl" option_transfer=$gui->opt_cfg}
  </div>
  
  {if $gui->opt_requirements==TRUE && $gui->grants->req_tcase_link_management=='yes' && isset($gui->tc.testcase_id)}
    <br />
    <div>
    <a href="javascript:openReqWindow({$gui->tc.testcase_id})">{$labels.assign_requirements}</a>    
    </div>
  {/if}
