#if defined _forms_included
 #endinput
#endif
#define _forms_included

native Forms_CreateForm(String:name[], String:title[], width, height, Function:callback, Function:closecallback=INVALID_FUNCTION);
native Forms_AddInput(form_id, String:type[], String:name[]="", String:value[]="", String:label[]="");
native Forms_SendForm(client, form_id);
native Forms_SendError(client, String:msg[]);
native Forms_CloseForm(client);