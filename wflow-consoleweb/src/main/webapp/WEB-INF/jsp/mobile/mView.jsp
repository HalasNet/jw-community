<%@ include file="/WEB-INF/jsp/includes/taglibs.jsp" %>
<%@page import="org.joget.apps.userview.model.UserviewMenu"%>
<%@page import="org.joget.workflow.util.WorkflowUtil"%>
<%@page contentType="text/html" pageEncoding="utf-8"%>

<c:set var="landingPage" value="landing"/>
<c:if test="${empty menuId && !empty userview.properties.homeMenuId}">
    <c:set var="homeRedirectUrl" scope="request" value="/web/"/>
    <c:if test="${embed}">
        <c:set var="homeRedirectUrl" scope="request" value="${homeRedirectUrl}embed/"/>
    </c:if>
    <c:set var="homeRedirectUrl" scope="request" value="${homeRedirectUrl}mobile/${appId}/${userview.properties.id}/${key}/${landingPage}"/>
    <c:redirect url="${homeRedirectUrl}"/>
</c:if>

<c:set var="isAnonymous" value="<%= WorkflowUtil.isCurrentUserAnonymous() %>"/>
<c:if test="${!empty userview.setting.permission && !userview.setting.permission.authorize && isAnonymous}">
    <c:set var="redirectUrl" scope="request" value="/web/"/>
    <c:choose>
        <c:when test="${embed}">
            <c:set var="redirectUrl" scope="request" value="${redirectUrl}embed/mlogin/${appId}/${userview.properties.id}/"/>
        </c:when>
        <c:otherwise>
            <c:set var="redirectUrl" scope="request" value="${redirectUrl}mlogin/${appId}/${userview.properties.id}/"/>
        </c:otherwise>
    </c:choose>
    <c:choose>
        <c:when test="${!empty key}">
            <c:set var="redirectUrl" scope="request" value="${redirectUrl}${key}"/>
        </c:when>
        <c:otherwise>
            <c:set var="redirectUrl" scope="request" value="${redirectUrl}______"/>
        </c:otherwise>
    </c:choose>
    <c:if test="${!empty menuId}">
        <c:set var="redirectUrl" scope="request" value="${redirectUrl}/${menuId}"/>
    </c:if>
    <c:redirect url="${redirectUrl}"/>
</c:if>

<c:set var="bodyId" scope="request" value=""/>
<c:choose>
    <c:when test="${!empty userview.setting.permission && !userview.setting.permission.authorize}">
        <c:set var="bodyId" scope="request" value="unauthorize"/>
    </c:when>
    <c:when test="${!empty userview.current}">
        <c:choose>
            <c:when test="${!empty userview.current.properties.customId}">
                <c:set var="bodyId" scope="request" value="${userview.current.properties.customId}"/>
            </c:when>
            <c:otherwise>
                <c:set var="bodyId" scope="request" value="${userview.current.properties.id}"/>
            </c:otherwise>
        </c:choose>
    </c:when>
    <c:otherwise>
        <c:set var="bodyId" scope="request" value="pageNotFound"/>
    </c:otherwise>
</c:choose>

<c:catch var="bodyError">
<c:set var="bodyContent">
    <c:choose>
        <c:when test="${!empty userview.current}">
            <c:set var="menuUrl" value="${userview.current.url}"/>
            <c:set var="menuUrl" value="${fn:replace(menuUrl, '/userview/', '/mobile/')}"/>
            <c:set target="${userview.current}" property="url" value="${menuUrl}"/>

            <c:set var="properties" scope="request" value="${userview.current.properties}"/>
            <c:set var="requestParameters" scope="request" value="${userview.current.requestParameters}"/>
            <c:set var="readyJspPage" value="${userview.current.readyJspPage}"/>
            <c:choose>
                <c:when test="${!empty readyJspPage}">
                    <jsp:include page="../${readyJspPage}" flush="true"/>
                </c:when>
                <c:otherwise>
                    ${userview.current.readyRenderPage}
                </c:otherwise>
            </c:choose>
        </c:when>
        <c:when test="${menuId != landingPage}">
            <h3><fmt:message key="ubuilder.pageNotFound"/></h3>

            <fmt:message key="ubuilder.pageNotFound.message"/>
            <br><br>
            <fmt:message key="ubuilder.pageNotFound.explanation"/>
            <p>&nbsp;</p>
            <p>&nbsp;</p>
            <p>
                <a href="${pageContext.request.contextPath}/web/mobile/${appId}/${userview.properties.id}/${key}/${userview.properties.homeMenuId}"><fmt:message key="ubuilder.pageNotFound.backToMain"/></a>
            </p>
        </c:when>
    </c:choose>
</c:set>

<c:set var="alertMessageProperty" value="<%= UserviewMenu.ALERT_MESSAGE_PROPERTY %>"/>
<c:set var="alertMessageValue" value="${userview.current.properties[alertMessageProperty]}"/>
<c:set var="redirectUrlProperty" value="<%= UserviewMenu.REDIRECT_URL_PROPERTY %>"/>
<c:set var="redirectUrlValue" value="${userview.current.properties[redirectUrlProperty]}"/>
<c:set var="redirectParentProperty" value="<%= UserviewMenu.REDIRECT_PARENT_PROPERTY %>"/>
<c:set var="redirectParentValue" value="${userview.current.properties[redirectParentProperty]}"/>
<c:choose>
<c:when test="${!empty redirectUrlValue}">
    <c:choose>
        <c:when test="${redirectParentValue}">
        </c:when>
        <c:otherwise>
            <c:if test="${!fn:containsIgnoreCase(redirectUrlValue, 'http') && !fn:startsWith(redirectUrlValue, '/')}">
                <c:set var="redirectBaseUrlValue" scope="request" value="/web/"/>
                <c:if test="${embed}">
                    <c:set var="redirectBaseUrlValue" scope="request" value="${redirectBaseUrlValue}embed/"/>
                </c:if>
                <c:set var="redirectBaseUrlValue" scope="request" value="${redirectBaseUrlValue}mobile/${appId}/${userview.properties.id}/${key}/"/>
                <c:set var="redirectUrlValue" value="${redirectBaseUrlValue}${redirectUrlValue}"/>
            </c:if>
            <c:if test="${fn:startsWith(redirectUrlValue, pageContext.request.contextPath)}">
                <c:set var="redirectUrlValue" value="${fn:replace(redirectUrlValue, pageContext.request.contextPath, '')}"/>
            </c:if>
            <c:redirect url="${redirectUrlValue}"/>
        </c:otherwise>
    </c:choose>
</c:when>
</c:choose>
</c:catch>
<!DOCTYPE html>
<html class="ui-mobile" manifest="${pageContext.request.contextPath}/web/mobilecache/${appId}/${userview.properties.id}">
    <head>
        <title>
            ${userview.properties.name} &nbsp;&gt;&nbsp;
            <c:if test="${!empty userview.current}">
                ${userview.current.properties.label}
            </c:if>
        </title>
        <meta name="viewport" content="width=device-width,initial-scale=1">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/mobile/jqm/jquery.mobile-1.3.1.css">
        <script src="${pageContext.request.contextPath}/js/jquery/jquery-1.9.1.min.js"></script>
        <script src="${pageContext.request.contextPath}/js/jquery/jquery-migrate-1.2.1.min.js"></script>
        <script src="${pageContext.request.contextPath}/js/jquery/ui/jquery-ui-1.10.3.min.js"></script>
        <script src="${pageContext.request.contextPath}/mobile/jqm/jquery.mobile-1.3.1.min.js"></script>
        <script src="${pageContext.request.contextPath}/mobile/jqm/jquery.cookie.js"></script>
        <script src="${pageContext.request.contextPath}/mobile/mobile.js"></script>
        <script>
            function desktopSite() {
                var path = "${pageContext.request.contextPath}/web/userview/${appId}/";
                var href = "${pageContext.request.contextPath}/web/userview/${appId}/${userview.properties.id}/${key}";
                Mobile.viewFullSite(path, href);
                return false;
            }
            Mobile.contextPath = "${pageContext.request.contextPath}";
            Mobile.updateCache();            
        </script>
        <script type="text/javascript" src="${pageContext.request.contextPath}/js/json/ui.js"></script>
        <script type="text/javascript" src="${pageContext.request.contextPath}/js/json/util.js"></script>
        <script type="text/javascript" src="${pageContext.request.contextPath}/js/json/formUtil.js"></script>
    </head>
    <body class="ui-mobile-viewport">

        <div id="userview" data-role="page" data-url="userview" tabindex="0" style="min-height: 377px; ">

            <div data-role="header" data-position="fixed" role="banner" style="top: 0px; ">
                <c:if test="${!empty menuId && menuId != landingPage}">
                    <a href="${pageContext.request.contextPath}/web/mobile/${appId}/${userview.properties.id}/${key}/${landingPage}" data-icon="home" data-direction="reverse"><fmt:message key="console.header.menu.label.home"/></a>
                </c:if>
                <h1 class="ui-title" tabindex="0" role="heading" aria-level="1">
                <c:choose>
                    <c:when test="${!empty userview.setting.theme.header}">
                        ${userview.setting.theme.header}
                    </c:when>
                    <c:otherwise>
                        ${userview.properties.name}
                    </c:otherwise>
                </c:choose>                    
                </h1>
                <c:if test="${empty menuId || menuId == landingPage}">    
                    <c:choose>
                        <c:when test="${isAnonymous}">
                            <a href="${pageContext.request.contextPath}/web/mlogin/${appId}/${userview.properties.id}/${key}" data-icon="gear" data-theme="b"><span id="loginText"><fmt:message key="console.login.label.login"/></span></a>
                            <a href="#" onclick="return desktopSite()" data-icon="home" rel="external"><fmt:message key="mobile.apps.desktop"/></a>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/j_spring_security_logout" data-icon="back" data-theme="b" data-direction="reverse"><span id="logoutText">${userview.properties.logoutText}</span></a>
                            <a href="#" onclick="return desktopSite()" data-icon="home" rel="external"><fmt:message key="mobile.apps.desktop"/></a>
                        </c:otherwise>
                    </c:choose>                            
                </c:if>
            </div>
            <div id="logo"></div>
            <div data-role="content" class="ui-content" role="main">
                <c:choose>
                    <c:when test="${empty menuId || menuId == landingPage}">
                        <ul id="menu" data-role="listview" data-filter="true" data-inset="true" class="ui-listview" data-filter-theme="d" data-theme="d" data-divider-theme="d">
                            <c:forEach items="${userview.categories}" var="category" varStatus="cStatus">
                                <c:if test="${category.properties.hide ne 'yes'}">                                        
                                    <li data-role="list-divider">
                                        <h3>${category.properties.label}</h3>
                                    </li>
                                    <c:forEach items="${category.menus}" var="menu" varStatus="mStatus">
                                        <li>
                                            ${menu.menu}
                                        </li>
                                    </c:forEach>
                                </c:if>
                            </c:forEach>                    
                        </ul>
                        <script>
                            Mobile.initDataList();
                        </script>
                    </c:when>
                    <c:otherwise>
                        ${bodyContent}
                        <c:if test="${!empty bodyError}">
                            ${bodyError}
                            <pre>
                            <%
                                Exception e = (Exception)pageContext.findAttribute("bodyError");
                                e.printStackTrace(new java.io.PrintWriter(out));
                            %>
                            </pre>
                        </c:if>
                    </c:otherwise>
                </c:choose>
            </div>		

        </div>
                    
        <div class="ui-loader" style="top: 332px; "></div>
        <div id="online-status"></div>
        <jsp:include page="mCss.jsp" flush="true"/>
    </body>    
</html>