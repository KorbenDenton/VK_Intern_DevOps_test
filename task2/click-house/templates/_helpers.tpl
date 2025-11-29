{{- define "clickhouse.name" -}}
{{ .Chart.Name }}
{{- end -}}

{{- define "clickhouse.fullname" -}}
{{ printf "%s-%s" .Release.Name (include "clickhouse.name" .) }}
{{- end -}}
