<?php
/**
 * @author 			Petar Dzhambazov
 * @category    ZetaPrints
 * @package     ZetaPrints_Attachments
 * @license     http://opensource.org/licenses/osl-3.0.php  Open Software License (OSL 3.0)
 */
$installer = $this;
$installer->startSetup();
$table = $installer->getTable('attachments/attachments');
$installer->run("
ALTER TABLE `{$table}`
 ADD `file_hash` CHAR(32) NOT NULL COMMENT 'current file path',
ADD INDEX(`file_hash`)");
$installer->run("
ALTER TABLE `{$table}` CHANGE `attachment_hash` `attachment_hash` CHAR( 32 ) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL
 "); // no need to be varchar, allow null as value
$installer->endSetup();
