
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<!-- basic styles -->
<link href="${ctx}/staticPublic/css/bootstrap.min.css" rel="stylesheet" />
<!-- page specific plugin styles -->
<!-- ace styles -->
<link rel="stylesheet" href="${ctx}/staticPublic/css/ace.min.css" />
<link rel="stylesheet" href="${ctx}/staticPublic/css/font-awesome.min.css" />
<!-- inline styles related to this page -->
<link rel="stylesheet" href="${ctx}/staticPublic/css/main.min.css" />
<link rel="stylesheet" href="${ctx}/staticPublic/css/ztree/demo.css" type="text/css" />
<!-- ace settings handler -->
<script type="text/javascript" src="${ctx}/staticPublic/js/ace-extra.min.js"></script><!--要预先加载ace的js-->

</head>
<body class="white-bg">
<div class="page-content">
	<div class="page-header">
		<h1>
			基础信息管理
			<small>
				<i class="icon-double-angle-right"></i>
				费用类型管理
			</small>
		</h1>
	</div><!-- /.page-header -->
	<div class="page-content">
		<div class="searchbox col-xs-12">
		   <label class="title">名称：</label>
		    <input id="name" class="form-box mul-form-box" type="text" placeholder="请输入名称" />
			<a class="itemBtn" onclick="searchInfo()">查询</a>
			<a class="itemBtn" onclick="addType()">新增</a>
		</div>
		<div class="detailInfo">
		<table id="detailtable" class="table table-striped table-bordered table-hover">
			<thead>
				<tr>														
					<th>序号</th>
					<th>名称</th>
					<th>备注</th>
                    <th>创建时间</th>
                    <th>更新时间</th>
                    <th>操作</th>
				</tr>
			</thead>
			<tbody>
			</tbody>
			</table>
			<!-- 新增费用类型设置-->
			<div class="modal fade" id="modal-add" tabindex="-1" role="dialog" data-backdrop="static">
				<div class="modal-dialog" style="padding-top:6%;">
				  <div class="modal-content">
				     <div class="modal-header" style="padding:0 15px;">
				        <button class="close" type="button" onclick="refresh();">×</button>
						<h3 id="myModalLabel">新增费用类型信息</h3>
				    </div>
					<div class="modal-body">
					    <div class="widget-box dia-widget-box">
							<div class="widget-body">
								<div class="widget-main">
									<div class="add-item extra-item">
								     <label class="title"><span class="red">*</span>名称：</label>
								     <input class="form-control" id="nameInfo" type="text" placeholder="请输入名称"/>
								    </div>
							  		<hr class="tree"></hr>
									 <div class="add-item extra-item">
									     <label class="title">备注：</label>
									     <input class="form-control" id="markInfo" type="text" placeholder="请输入备注"/>
									 </div>
							  		<hr class="tree"></hr>
								    <div class="add-item-btn dis-block" id="addBtn">
									    <a class="add-itemBtn btnOk" onclick="save();">保存</a>
									    <a class="add-itemBtn btnCancle" onclick="refresh();">取消</a>
									 </div> 
									</div>
						       </div>
					     </div>
					  </div>
				   </div>
				 </div>
			 </div>
			<!-- 编辑价格设置 -->
			<div class="modal fade" id="modal-edit" tabindex="-1" role="dialog" data-backdrop="static">
				<div class="modal-dialog" style="padding-top:6%;">
				  <div class="modal-content">
				     <div class="modal-header" style="padding:0 15px;">
				        <button class="close" type="button" onclick="updateCancle()">×</button>
						<h3>编辑费用类型信息</h3>
				    </div>
					<div class="modal-body">
					    <div class="widget-box dia-widget-box">
							<div class="widget-body">
								<div class="widget-main">
								   <div class="add-item extra-item">
								     <label class="title"><span class="red">*</span>名称：</label>
								     <input class="form-control" id="nameShow" type="text" placeholder="请输入名称"/>
								     <input type="hidden" id="id-hidden"/>
								    </div>
							  		<hr class="tree"></hr>
									 <div class="add-item extra-item">
									     <label class="title">备注：</label>
									     <input class="form-control" id="markShow" type="text" placeholder="请输入备注"/>
									 </div>
							  		<hr class="tree"></hr>
									 <div class="add-item-btn dis-block" id="editBtn">
									    <a class="add-itemBtn btnOk" onclick="update()">保存</a>
									    <a class="add-itemBtn btnCancle" onclick="updateCancle()">取消</a>
									  </div>
									</div>
						  </div>
					  </div>
					</div>
				  </div>
				</div>
			</div>
		</div>
	</div>
</div>

<script src="${ctx}/staticPublic/js/jquery-2.0.3.min.js"></script>
<script src="${ctx}/staticPublic/js/bootstrap.min.js"></script>
<!-- ace scripts -->
<script src="${ctx}/staticPublic/js/ace-elements.min.js"></script>
<script src="${ctx}/staticPublic/js/ace.min.js"></script>
<!-- inline scripts related to this page -->
<script type="text/javascript" src="${ctx}/staticPublic/js/bootbox.min.js"></script>
<script src="${ctx}/staticPublic/js/jquery.dataTables.js"></script>
<script src="${ctx}/staticPublic/js/jsonDataFormat.js"></script>
<script src="${ctx}/staticPublic/js/jquery.dataTables.bootstrap.js"></script>
<script type="text/javascript">
function init(){
	//initiate dataTables plugin
	var myTable = $('#detailtable').DataTable({
		 dom: 'Bfrtip',
		 "bLengthChange": false,//屏蔽tables的一页展示多少条记录的下拉列表
		 "bFilter": false,    //不使用过滤功能  
		 "bProcessing": true, //加载数据时显示正在加载信息
		 "bServerSide": true, //指定从服务器端获取数据
		 "sAjaxSource": "${ctx}/basicSetting/costType/getListData" , //获取数据的ajax方法的URL							 
		 "ordering": false,	
			"oLanguage": {
				"sLengthMenu": "每页显示 _MENU_ 条记录",
				"sZeroRecords": "抱歉， 没有找到",
				"sInfo": "从 _START_ 到 _END_ /共 _TOTAL_ 条数据",
				"sInfoEmpty": "没有数据",
				"sInfoFiltered": "(从 _MAX_ 条数据中检索)",
				"oPaginate": {
				"sFirst": "首页",
				"sPrevious": "上一页",
				"sNext": "下一页",
				"sLast": "尾页"
				},
				"sZeroRecords": "没有检索到数据"
				},		
		 columns: [{ data: "rownum","width":"5%"},
		    {data: "name","width":"20%"},
		    {data: "mark","width":"15%"},
		    {data: "insertTime","width":"20%"},
		    {data: "updateTime","width":"20%"},
		    {data: null,"width":"20%"}],
		    columnDefs: [
				{
					 //创建时间
					 targets: 3,
					 render: function (data, type, row, meta) {
				           if(data!='' && data!=null){
				        	   return jsonDateFormat(data);
				           }else{
				        	   return '';
				           }
				       }	       
				},
				{
					 //更新时间
					 targets: 4,
					 render: function (data, type, row, meta) {
						 if(data!='' && data!=null){
				        	   return jsonDateFormat(data);
				           }else{
				        	   return '';
				           }
				       }	       
				},
		      	{
			    	 //操作栏
			    	 targets: 5,
			    	 render: function (data, type, row, meta) {
		                    return '<a class="table-edit" onclick="doedit('+ row.id +')">编辑</a>'
						           +'<a class="table-delete" onclick="dodelete('+ row.id +')">删除</a>';
		                }	       
		    	} 
		      ],
	        "fnServerData":retrieveData //与后台交互获取数据的处理函数
    });
}
function reload(){
	//reload dataTables plugin
	var myTable = $('#detailtable').DataTable({
		"destroy": true,//如果需要重新加载需销毁
		 dom: 'Bfrtip',
		 "bLengthChange": false,//屏蔽tables的一页展示多少条记录的下拉列表
		 "bFilter": false,    //不使用过滤功能  
		 "bProcessing": true, //加载数据时显示正在加载信息
		 "bServerSide": true, //指定从服务器端获取数据
		 "sAjaxSource": "${ctx}/basicSetting/costType/getListData" , //获取数据的ajax方法的URL	
		 "ordering": false,	
			"oLanguage": {
				"sLengthMenu": "每页显示 _MENU_ 条记录",
				"sZeroRecords": "抱歉， 没有找到",
				"sInfo": "从 _START_ 到 _END_ /共 _TOTAL_ 条数据",
				"sInfoEmpty": "没有数据",
				"sInfoFiltered": "(从 _MAX_ 条数据中检索)",
				"oPaginate": {
				"sFirst": "首页",
				"sPrevious": "上一页",
				"sNext": "下一页",
				"sLast": "尾页"
				},
				"sZeroRecords": "没有检索到数据"
				},		
				columns: [{ data: "rownum","width":"5%"},
						    {data: "name","width":"20%"},
						    {data: "mark","width":"15%"},
						    {data: "insertTime","width":"20%"},
						    {data: "updateTime","width":"20%"},
						    {data: null,"width":"20%"}],
						    columnDefs: [
								{
									 //创建时间
									 targets: 3,
									 render: function (data, type, row, meta) {
								           if(data!='' && data!=null){
								        	   return jsonDateFormat(data);
								           }else{
								        	   return '';
								           }
								       }	       
								},
								{
									 //更新时间
									 targets: 4,
									 render: function (data, type, row, meta) {
										 if(data!='' && data!=null){
								        	   return jsonDateFormat(data);
								           }else{
								        	   return '';
								           }
								       }	       
								},
						      	{
							    	 //操作栏
							    	 targets: 5,
							    	 render: function (data, type, row, meta) {
						                    return '<a class="table-edit" onclick="doedit('+ row.id +')">编辑</a>'
										           +'<a class="table-delete" onclick="dodelete('+ row.id +')">删除</a>';
						                }	       
						    	} 
						      ],
					        "fnServerData":retrieveData //与后台交互获取数据的处理函数
    });
}
$(function(){
	init();
})

/* 数据交互 */
function retrieveData( sSource, aoData, fnCallback ) {
	   var name=$('#name').val();
	   var secho=aoData[0]["value"];   
	   var pageStartIndex=aoData[3]["value"];
	   var pageSize=aoData[4]["value"];
	   $('#secho').val(secho);
	   var obj = {};
		 $.ajax({
			type : 'POST',
			url : sSource,
			data : JSON.stringify({
				sEcho : $.trim(secho),				
				pageStartIndex : $.trim(pageStartIndex),
				pageSize : $.trim(pageSize),
				name : name
			}),
			contentType : "application/json;charset=UTF-8",
			dataType : 'JSON',
			success : function(data) {
				if (data && data.code == 200) {						
					obj.iTotalDisplayRecords=data.data.totalCounts;
					obj.iTotalRecords=data.data.totalCounts;
					obj.aaData=data.data.records;		
					obj.sEcho=data.data.frontParams;
					if(obj.aaData.length>0){
						for(var i=0;i<obj.aaData.length;i++){
							obj.aaData[i]["rownum"]=i+1;
						}
					}else{
						obj.aaData=[];
					}
					fnCallback(obj); //服务器端返回的对象的returnObject部分是要求的格式  	
				} else {
					 bootbox.alert(data.msg);
				}
				
			}
		}); 
	   
	}
/* 查询 */
function searchInfo(){
	reload();
}

/* 删除 */
function dodelete(id){
	var flag="false";
	bootbox.confirm({ 
		  size: "small",
		  message: "确定要删除该费用类型信息?", 
		  callback: function(result){
			  if(result){
				  $.ajax({
						type : 'GET',
						url : "${ctx}/basicSetting/costType/delete/"+id,
						data :{},
						dataType : 'JSON',
						success : function(data) {
							if (data && data.code == 200) {
								bootbox.confirm_alert({ 
									  size: "small",
									  message: "删除成功！", 
									  callback: function(result){
										  if(result){
											  flag="true";
											  reload();
										  }else{
											 reload();  
										  }
									  }
								 });
								setTimeout(function(){
									if(flag=="false"){
										 reload();
										 $('.bootbox').modal('hide');
									}
								},3000);
							} else {
								bootbox.alert(data.msg);
							}
						}
						
					}); 
			  }
		  }
	})
};

/*新增信息输入  */
function addType(){
	clear();
	$('#modal-add').modal('show');
}
/* 关闭窗体 */
function refresh(){
	$('#modal-add').modal('hide');
	
}
/* 数据重置 */
function clear(){
	$('#nameInfo').val('');
	$('#markInfo').val('');
}
/* 保存新增价格信息 */
function save(){
	var flag="false";
	var name=$('#nameInfo').val();
	var mark=$('#markInfo').val();
	if(name==''){
		bootbox.alert('名称不能为空！');
		return;
	}
	bootbox.confirm({ 
		  size: "small",
		  message: "确定要保存该费用类型信息吗?", 
		  callback: function(result){
			  if(result){
					$.ajax({
						type : 'POST',
						url : '${ctx}/basicSetting/costType/save',
						data : JSON.stringify({
							name :name,
							mark :mark,
							type :''
						}),
						contentType : "application/json;charset=UTF-8",
						dataType : 'JSON',
						success : function(data) {
							if (data && data.code == 200) {
								bootbox.confirm_alert({ 
									  size: "small",
									  message: "保存成功！", 
									  callback: function(result){
										  if(result){
											  flag="true";
											  reload();
											  $('#modal-add').modal('hide');
										  }else{
											 reload();
											 $('#modal-add').modal('hide');
										  }
									  }
								 });
								setTimeout(function(){
									if(flag=="false"){
										 reload();
										 $('.bootbox').modal('hide');
										 $('#modal-add').modal('hide');
									}
								},3000);
							} else {
								bootbox.alert(data.msg);
							}
							
						}
						
					});
			  }
		  }
		});
}

function doedit(id){
	$('#id-hidden').val(id);
	$.ajax({
		type : 'GET',
		url : "${ctx}/basicSetting/costType/getById/"+id,
		data :{},
		dataType : 'JSON',
		success : function(data) {
			if (data && data.code == 200) {
				if(data.data.name!=null){
					$('#nameShow').val(data.data.name);
				}else{
					$('#nameShow').val('');
				}
				$('#markShow').val(data.data.mark);
				$('#modal-edit').modal('show');
				
			} else {
				bootbox.alert(data.msg);				
			}
		}
		
	}); 
}
/* 关闭窗体 */
function updateCancle(){
	$('#modal-edit').modal('hide');
	
}
/* 更新 */
function update(){
	var id=$('#id-hidden').val();
	var flag="false";
	var name=$('#nameShow').val();
	var mark=$('#markShow').val();
	if(name==''){
		bootbox.alert('名称不能为空！');
		return;
	}
	bootbox.confirm({ 
		  size: "small",
		  message: "确定要保存该费用类型信息吗?", 
		  callback: function(result){
			  if(result){
					$.ajax({
						type : 'POST',
						url : '${ctx}/basicSetting/costType/save',
						data : JSON.stringify({
							id : id,
							name : name,
							mark :mark,
							type :''
						}),
						contentType : "application/json;charset=UTF-8",
						dataType : 'JSON',
						success : function(data) {
							if (data && data.code == 200) {
								bootbox.confirm_alert({ 
									  size: "small",
									  message: "保存成功！", 
									  callback: function(result){
										  if(result){
											  flag="true";
											  reload();
											  $('#modal-edit').modal('hide');
										  }else{
											 reload();
											 $('#modal-edit').modal('hide');
										  }
									  }
								 });
								setTimeout(function(){
									if(flag=="false"){
										 reload();
										 $('.bootbox').modal('hide');
										 $('#modal-edit').modal('hide');
									}
								},3000);
							} else {
								bootbox.alert(data.msg);
							}
							
						}
						
					});
			  }
		  }
		});
}

</script>



</body>
</html>






