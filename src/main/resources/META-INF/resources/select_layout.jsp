<%@page import="com.liferay.portal.kernel.util.PropsUtil"%>

<%
	// Get the site template's groupId from portal-ext.properties
	long siteTemplateGroupId = GetterUtil.getLong(PropsUtil.get("site.template.group.id"));

	if ((siteTemplateGroupId > 0) && (themeDisplay.getCompanyGroupId() == themeDisplay.getScopeGroupId())) {
		// Apply this customization only in global scope and if a 
		// site.template.group.id has been configured
%>

<aui:script use="aui-base">

	var portletNamespace = '<%= liferayPortletResponse.getNamespace() %>';
	var groupIdNode = A.one('#' + portletNamespace + 'groupId');
	var currentGroupId = groupIdNode.get('value');
	var fieldname = '';
	
	var selectButtons = A.all('[id^="<%= liferayPortletResponse.getNamespace() %>"][id$="SelectButton"]');	
	
	// Add custom event listeners to the link-to-layout 
	// field's select buttons
	selectButtons.each(function (selectButton) {
	
		selectButton.on('click', function(event) {
			
			fieldname = this.get('id').replace('SelectButton', '');
			
			// Set the form's groupId to the site template's groupId 
			// before opening the select layout modal
	  	  	groupIdNode.set('value', '<%= siteTemplateGroupId %>');
	  	  	
		});
	}); 
	
	// Restore the original groupId (= groupId of the instances global scope)
	// and fix path entries when the modal is closed
	document.addEventListener('click', function(event){
	  
	  if (event.target.closest('.lfr-ddm-link-to-page-modal-content .btn-default') || 
	      event.target.closest('.lfr-ddm-link-to-page-modal-content .close-content')) {
		
		// Restore the currentGroupId when 
	  	// the layout select modal is closed
		groupIdNode.set('value', currentGroupId);
		
		// Fix the groupId of the root node
		var linkToPageField = A.one('#' + fieldname); 
		var linkToPageValue = JSON.parse(linkToPageField.get('value'));
		
		var rootNode = linkToPageValue.path[0];		
		rootNode.groupId = <%= siteTemplateGroupId %>;
		linkToPageValue.path[0] = rootNode;
		linkToPageField.set('value', JSON.stringify(linkToPageValue));	
			  	
	  }
	})	
			
</aui:script>

<%
	}
%>