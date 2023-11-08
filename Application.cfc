<cfcomponent>

    <!-- Application settings -->
    <cfset THIS.Name = "YourAppName">
    <cfset THIS.ApplicationTimeout = CreateTimeSpan(0,1,0,0)>
    <cfset THIS.SessionManagement = true>
    <cfset THIS.SessionTimeout = CreateTimeSpan(0,0,30,0)>
    
</cfcomponent>
