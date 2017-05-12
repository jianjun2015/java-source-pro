USE `eif_inspection`;

ALTER TABLE t_ins_check_result_detail  MODIFY COLUMN checked_data_no varchar(256) COMMENT '数据编号';
ALTER TABLE t_ins_check_result_detail add COLUMN src_value varchar(128) DEFAULT NULL COMMENT '源值';
ALTER TABLE t_ins_check_result_detail add COLUMN target_value varchar(128) DEFAULT NULL COMMENT '目标值';
ALTER TABLE t_ins_check_result_detail add COLUMN check_rule_name varchar(32) DEFAULT NULL COMMENT '检查规则名称';
ALTER TABLE t_ins_check_result_detail add COLUMN handle_msg varchar(32) DEFAULT NULL COMMENT '处理说明';
ALTER TABLE t_inspection ADD COLUMN ds_name VARCHAR (32);

ALTER TABLE t_ins_check_def add COLUMN diff_handler_name varchar(32) DEFAULT NULL COMMENT '差异处理器名称';
ALTER TABLE t_ins_check_result add COLUMN diff_handler_name varchar(32) DEFAULT NULL COMMENT '差异处理器名称';

CREATE TABLE `t_ins_diff_handler` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键Id',
  `create_by` varchar(32) DEFAULT NULL COMMENT '创建人',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `modify_by` varchar(32) DEFAULT NULL COMMENT '最近修改人',
  `modify_time` datetime NOT NULL COMMENT '最近修改时间',
  `handler_name` varchar(32) NOT NULL COMMENT '处理器名称',
  `handle_type` varchar(16) NOT NULL COMMENT '处理方式',
  `handle_topic` varchar(64) DEFAULT NULL COMMENT '处理方topic',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_diff_handler_1` (`handler_name`),
  KEY `idx_diff_handler_2` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='差异处理器';

ALTER TABLE t_ins_check_result_detail add COLUMN  data_no  varchar(32) DEFAULT NULL COMMENT '数据编号';
update t_ins_check_result_detail l set l.data_no=l.id where l.data_no is null;
ALTER TABLE t_ins_check_result_detail  MODIFY COLUMN data_no varchar(32) NOT NULL COMMENT '数据编号';
ALTER  TABLE  t_ins_check_result_detail  ADD  UNIQUE t_check_result_detail_3(`data_no` );
alter table t_ins_check_result_detail change checked_data_no  data_marker varchar(256) DEFAULT NULL COMMENT '数据编号';


CREATE TABLE `t_ins_check_result_handle_log` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键Id',
  `create_by` varchar(32) DEFAULT NULL COMMENT '创建人',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `result_detail_id` bigint(20) NOT NULL COMMENT '结果明细Id',
  `handle_status` varchar(16) NOT NULL COMMENT '处理状态',
  `handle_type` varchar(32) DEFAULT NULL,
  `handle_msg` varchar(512) DEFAULT NULL COMMENT '处理说明',
  `handler` varchar(32) NOT NULL COMMENT '处理人',
  `remark` varchar(256) DEFAULT NULL COMMENT '备注，说明',
  PRIMARY KEY (`id`),
  KEY `idx_checkResultHandleLog_1` (`result_detail_id`),
  KEY `idx_checkResultHandleLog_2` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='结果处理日志';

ALTER TABLE t_ins_check_result_detail  add COLUMN  handle_duration int(11) DEFAULT NULL COMMENT '处理时长';
ALTER TABLE t_ins_check_result_detail add COLUMN warn_on_timeout tinyint(1) DEFAULT NULL COMMENT '超时未处理发出警告';

CREATE TABLE `t_ins_extract_data_rule` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键Id',
  `create_by` varchar(32) DEFAULT NULL COMMENT '创建人',
  `modify_by` varchar(32) DEFAULT NULL COMMENT '修改人',
  `ext_name` varchar(32) DEFAULT NULL COMMENT '数据抽取规则名称',
  `rule_params` varchar(128) DEFAULT NULL COMMENT '全局规则参数',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `modify_time` datetime NOT NULL COMMENT '修改时间',
  `remark` varchar(256) DEFAULT NULL COMMENT '备注，说明',
  PRIMARY KEY (`id`),
  UNIQUE KEY `t_ins_extract_data_rule_1` (`ext_name`),
  KEY `t_ins_extract_data_rule_2` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='数据抽取规则';

CREATE TABLE `t_ins_extract_data_rule_detail` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键Id',
  `orderNo` int(20) NOT NULL COMMENT '编号',
  `ext_rule_id` bigint(20) NOT NULL COMMENT '抽取规则ID',
  `title_name` varchar(32) DEFAULT NULL COMMENT '显示标题',
  `prepared_sql` varchar(4096) NOT NULL COMMENT '查询sql：符合jdbc的prepare sql 的规范',
  `sql_params` varchar(128) DEFAULT NULL COMMENT '参数列表',
  `data_source` varchar(32) NOT NULL COMMENT '数据源名称',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `remark` varchar(256) DEFAULT NULL COMMENT '备注，说明',
  PRIMARY KEY (`id`),
  KEY `t_ins_extract_data_rule_detail_1` (`ext_rule_id`),
  KEY `t_ins_extract_data_rule_detail_2` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='数据抽取规则明细';

ALTER TABLE t_inspection_rule  add COLUMN  rule_type VARCHAR (10) NOT NULL COMMENT '对账规则类型';
ALTER TABLE t_inspection_rule  add COLUMN  link_info VARCHAR (128) DEFAULT '' COMMENT '远程连接信息';
ALTER TABLE t_inspection_rule  add COLUMN  shell_loc VARCHAR (128) DEFAULT '' COMMENT 'shell脚本路径';
