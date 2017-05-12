CREATE DATABASE `eif_inspection` DEFAULT CHARSET=utf8;

USE `eif_inspection`;

CREATE TABLE `t_inspection_rule` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `inspection_name` varchar(64) NOT NULL COMMENT '检查名称',
  `order_no` int(3) unsigned NOT NULL COMMENT '执行顺序号',
  `expect_result` varchar(64) NOT NULL COMMENT '期望结果',
  `msg_on_unexpected` varchar(256) DEFAULT NULL COMMENT '不符合期望时的提示消息',
  `inspection_sql` varchar(4096) NOT NULL COMMENT '检查sql，符合jdbc的prepare sql的语法',
  `parameters` varchar(2048) DEFAULT NULL COMMENT '参数，json格式',
  `remark` varchar(128)  NULL COMMENT '备注',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`),
   KEY `idx_inspection_rule_1` (`inspection_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `t_inspection` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `inspection_name` varchar(64) NOT NULL COMMENT '检查名称',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_inspectionName` (`inspection_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



CREATE TABLE `t_inspection_result` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `inspection_name` varchar(64) NOT NULL COMMENT '检查名称',
  `rule_content` varchar(8192) NOT NULL,
  `inspect_result` varchar(32) NOT NULL,
  `fail_msg` varchar(256) DEFAULT NULL COMMENT '失败消息',
  `latest_inspect_order_no` varchar(8) NOT NULL COMMENT '检查节点序号',
  `create_time` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `t_ins_fwd` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键Id',
  `create_by` varchar(32) DEFAULT NULL COMMENT '创建人',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `curr_date` date NOT NULL COMMENT '当前日期',
  `is_fwd` tinyint(1) NOT NULL COMMENT '是否为金融工作日',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_fwd_1` (`curr_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='金融工作日信息表';


##   新的对账脚本
CREATE TABLE `t_ins_data_source_def` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键Id',
  `create_by` varchar(32) DEFAULT NULL COMMENT '创建人',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `modify_by` varchar(32) DEFAULT NULL COMMENT '最近修改人',
  `modify_time` datetime NOT NULL COMMENT '最近修改时间',
  `ds_name` varchar(32) NOT NULL COMMENT '数据源名称,唯一',
  `ds_type` varchar(16) NOT NULL DEFAULT 'mysql' COMMENT '数据库类型,默认mysql',
  `jdbc_url` varchar(512) NOT NULL COMMENT '数据库连接地址',
  `ds_user_name` varchar(32) NOT NULL COMMENT '数据库用户名',
  `ds_password` varchar(64) NOT NULL COMMENT '数据用户密码',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_t_data_source_def_1` (`ds_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='数据源定义表';


CREATE TABLE `t_ins_check_def` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键Id',
  `create_by` varchar(32) DEFAULT NULL COMMENT '创建人',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `modify_by` varchar(32) DEFAULT NULL COMMENT '最近修改人',
  `modify_time` datetime NOT NULL COMMENT '最近修改时间',
  `check_name` varchar(32) NOT NULL COMMENT '任务名称,唯一',
  `enabled` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否有效',
  `src_data_source` varchar(32) NOT NULL COMMENT '源数据源名称',
  `src_prepared_sql` varchar(4096) NOT NULL COMMENT '查询sql：符合jdbc的prepare sql 的规范',
  `src_sql_params` varchar(128) DEFAULT NULL COMMENT '参数',
  `src_relation_key` varchar(32) NOT NULL COMMENT '关联字段列名',
  `target_data_source` varchar(32) NOT NULL COMMENT '标数据源名称',
  `target_match_sql` varchar(2048) NOT NULL COMMENT '目标比对sql',
  `target_relation_key` varchar(32) NOT NULL COMMENT '目标关联字段列名(可以带表的别名)',
  `query_strategy` varchar(16) NOT NULL COMMENT '比对数据查询策略',
  `edition` int(10) unsigned NOT NULL DEFAULT '1' COMMENT '版本号，用于乐观锁控制',
  PRIMARY KEY (`id`),
  UNIQUE KEY `t_check_def_1` (`check_name`),
  KEY `t_check_def_2` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='对账任务定义表';

CREATE TABLE `t_ins_check_rule` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键Id',
  `create_by` varchar(32) DEFAULT NULL COMMENT '创建人',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `check_id` bigint(20) NOT NULL COMMENT '对账定义编号',
  `name` varchar(32) NOT NULL COMMENT '规则名称',
  `src_col` varchar(32) NOT NULL COMMENT '源列名',
  `target_col` varchar(32) NOT NULL COMMENT '目标列名',
  `match_strategy` varchar(16) NOT NULL COMMENT '比对策略',
  `mappers_json` varchar(256) DEFAULT NULL COMMENT '值映射列表，json格式',
  PRIMARY KEY (`id`),
  UNIQUE KEY `t_check_rule_1` (`check_id`,`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='对账规则';

CREATE TABLE `t_ins_check_plan` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键Id',
  `create_by` varchar(32) DEFAULT NULL COMMENT '创建人',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `modify_by` varchar(32) DEFAULT NULL COMMENT '最近修改人',
  `modify_time` datetime NOT NULL COMMENT '最近修改时间',
  `plan_name` varchar(32) NOT NULL COMMENT '计划名称',
  `enabled` tinyint(1) NOT NULL COMMENT '是否可用',
  `plan_type` varchar(16) NOT NULL COMMENT '计划类型',
  `cron` varchar(32) DEFAULT NULL COMMENT 'cron表达式',
  `params_json` varchar(256) DEFAULT NULL COMMENT '任务执行参数:json格式',
  `plan_status` varchar(16) NOT NULL COMMENT '计划状态',
  `lts_task_id` varchar(64) DEFAULT NULL COMMENT '关联的对账定义',
  `ref_check_name` varchar(32) NOT NULL COMMENT '关联的对账定义',
  `remark` varchar(255) DEFAULT NULL COMMENT '计划备注',
  `last_run_time` datetime DEFAULT NULL COMMENT '计划上次执行时间',
  `last_run_result` varchar(32) DEFAULT NULL,
  `last_run_msg` varchar(256) DEFAULT NULL,
   `edition` int(10) unsigned NOT NULL DEFAULT '1' COMMENT '版本号，用于乐观锁控制',
   `run_status` varchar(16) DEFAULT NULL COMMENT '执行状态',
  PRIMARY KEY (`id`),
  UNIQUE KEY `t_check_paln_1` (`plan_name`),
  KEY `t_check_paln_2` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='对账计划';

CREATE TABLE `t_ins_check_plan_log` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键Id',
  `create_by` varchar(32) DEFAULT NULL COMMENT '创建人',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `plan_id` bigint(20) NOT NULL COMMENT '计划编号',
  `action` varchar(16) NOT NULL COMMENT '动作',
  `operator` varchar(32) NOT NULL COMMENT '操作人',
  `remark` varchar(64) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`),
  KEY `t_check_plan_log_1` (`plan_id`),
  KEY `t_check_plan_log_2` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='对账计划操作日志';


CREATE TABLE `t_ins_check_result` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键Id',
  `create_by` varchar(32) DEFAULT NULL COMMENT '创建人',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `modify_by` varchar(32) DEFAULT NULL COMMENT '最近修改人',
  `modify_time` datetime NOT NULL COMMENT '最近修改时间',
  `check_name` varchar(32) NOT NULL COMMENT '对账名称',
  `plan_id` bigint(20) NOT NULL COMMENT '计划编号',
   `plan_type` varchar(16) NOT NULL COMMENT '计划类型',
  `plan_name` varchar(32) NOT NULL COMMENT '计划名称',
  `result` varchar(16) NOT NULL COMMENT '执行结果',
  `result_msg` varchar(64) DEFAULT NULL COMMENT '执行结果说明',
  `check_records` int(10) NOT NULL COMMENT '检查记录数',
  `fail_records` int(10) NOT NULL COMMENT '失败记录数',
  `run_time` datetime NOT NULL COMMENT '执行时间',
  `rule_content` varchar(8192) NOT NULL COMMENT '检查规则(冗余)',
  PRIMARY KEY (`id`),
  KEY `t_check_result_1` (`check_name`),
  KEY `t_check_result_2` (`plan_id`),
  KEY `t_check_result_3` (`create_time`),
  KEY `t_check_result_4` (`plan_name`),
  KEY `t_check_result_5` (`run_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='对账结果';


CREATE TABLE `t_ins_check_result_detail` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键Id',
  `create_by` varchar(32) DEFAULT NULL COMMENT '创建人',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `modify_by` varchar(32) DEFAULT NULL COMMENT '最近修改人',
  `modify_time` datetime NOT NULL COMMENT '最近修改时间',
  `checked_data_no` varchar(32) NOT NULL COMMENT '数据标识号',
  `check_remark` varchar(256) DEFAULT NULL COMMENT '比对说明',
  `diff_type` varchar(16) NOT NULL COMMENT '差异类型',
  `handle_status` varchar(16) NOT NULL COMMENT '处理状态',
  `handle_time` datetime DEFAULT NULL COMMENT '处理时间',
  `handle_type` varchar(32) DEFAULT NULL,
  `handle_operator` varchar(32) DEFAULT NULL COMMENT '处理人',
  `check_result_id` bigint(20) NOT NULL COMMENT '检查结果编号',
  PRIMARY KEY (`id`),
  KEY `t_check_result_detail_1` (`check_result_id`),
  KEY `t_check_result_detail_2` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



