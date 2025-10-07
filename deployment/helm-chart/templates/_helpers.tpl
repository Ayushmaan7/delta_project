{{- define "mini-airbnb.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "mini-airbnb.fullname" -}}
{{- printf "%s-%s" .Release.Name (include "mini-airbnb.name" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

