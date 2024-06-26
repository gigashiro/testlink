<?php
/**
 * TestLink Open Source Project - http://testlink.sourceforge.net/
 *                                https://github.com/TestLinkOpenSourceTRMS/testlink-code
 * 
 * This script is distributed under the GNU General Public License 2 or later.
 *
 * @filesource  rolesView.php
**/
require_once("../../config.inc.php");
require_once("common.php");
require_once("users.inc.php");
require_once("roles.inc.php");
testlinkInitPage($db,false,false,"checkRights");

$templateCfg = templateConfiguration();
init_global_rights_maps();
$args = init_args();
$gui = initializeGui($db,$args);

$doDelete = false;
$role = null;

switch ($args->doAction) {
  case 'delete':
    $role = tlRole::getByID($db,$args->roleid,tlRole::TLOBJ_O_GET_DETAIL_MINIMUM);
    if ($role)
    {
      $gui->affectedUsers = (array)$role->getAllUsersWithRole($db);
      $doDelete = (sizeof($gui->affectedUsers) == 0);
    }
  break;

  case 'confirmDelete':
    $doDelete = true;
  break;


  default:
  break;
}

$userFeedback = null;
if($doDelete)
{

  /*
  // CSRF check
  if( !is_null($args->csrfid) && !is_null($args->csrftoken) && 
      csrfguard_validate_token($args->csrfid,$args->csrftoken) )
  {
    // only NON SYSTEM ROLES CAN be deleted
    if($args->roleid > TL_LAST_SYSTEM_ROLE)
    {   
      $userFeedback = deleteRole($db,$args->roleid);
      checkSessionValid($db);  //refresh the current user
    }
  }
  else
  {
    $msg = lang_get('CSRF_attack');
    tLog($msg,'ERROR');
    die($msg);
  } 
  */ 

  // only NON SYSTEM ROLES CAN be deleted
  if($args->roleid > TL_LAST_SYSTEM_ROLE) {   
    $userFeedback = deleteRole($db,$args->roleid);
    checkSessionValid($db);  //refresh the current user
  }

}

$gui->roles = tlRole::getAll($db,null,null,null,tlRole::TLOBJ_O_GET_DETAIL_MINIMUM);


$smarty = new TLSmarty();
$smarty->assign('gui',$gui);
$smarty->assign('sqlResult',$userFeedback);
$smarty->display($templateCfg->template_dir . $templateCfg->default_template);

/**
 * @return object returns the arguments for the page
 */
function init_args()
{
  $iParams = [
    "tproject_id" => [tlInputParameter::INT_N],
    "tplan_id" => [tlInputParameter::INT_N],
    "roleid" => [tlInputParameter::INT_N],
    "csrfid" => [tlInputParameter::STRING_N,0,30],
    "csrftoken" => [tlInputParameter::STRING_N,0,128],
    "doAction" => [tlInputParameter::STRING_N,0,15]
  ];

  $args = new stdClass();
  R_PARAMS($iParams,$args);
  $args->currentUser = $_SESSION['currentUser'];
  
  return $args;
}

/**
 *
 */
function initializeGui(&$db,&$args) {
  $gui = new stdClass();
  $gui->tproject_id = $args->tproject_id;
  $gui->tplan_id = $args->tplan_id;

  $gui->highlight = initialize_tabsmenu();
  $gui->highlight->view_roles = 1;
  $gui->grants = getGrantsForUserMgmt($db,$args->currentUser);
  $gui->affectedUsers = null;
  $gui->roleid = $args->roleid;
  $gui->main_title = lang_get('role_management');
  $gui->role_id_replacement = config_get('role_replace_for_deleted_roles');
  $cfg = getWebEditorCfg('role');
  $gui->editorType = $cfg['type'];
  
  return $gui;
}


/**
 * @param $db resource the database connection handle
 * @param $user the current active user
 * 
 * @return boolean returns true if the page can be accessed
 */
function checkRights(&$db,&$user)
{
  return $user->hasRight($db,"role_management");
}