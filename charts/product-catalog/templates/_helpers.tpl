{{- define "product-catalog.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "product-catalog.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{- define "product-catalog.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "product-catalog.labels" -}}
helm.sh/chart: {{ include "product-catalog.chart" . }}
{{ include "product-catalog.selectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/part-of: opentelemetry-demo
{{- end }}

{{- define "product-catalog.selectorLabels" -}}
app.kubernetes.io/name: {{ include "product-catalog.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: product-catalog
opentelemetry.io/name: product-catalog
{{- end }}

{{- define "product-catalog.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "product-catalog.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "product-catalog.image" -}}
{{- $tag := .Values.image.tag | default (printf "%s-product-catalog" .Chart.AppVersion) -}}
{{- printf "%s:%s" .Values.image.repository $tag -}}
{{- end }}

{{- define "product-catalog.otelEndpoint" -}}
{{- if .Values.otel.exporterEndpoint }}
{{- .Values.otel.exporterEndpoint }}
{{- else }}
{{- printf "http://%s:4317" .Values.otel.collectorName }}
{{- end }}
{{- end }}

{{/*
PostgreSQL connection string
*/}}
{{- define "product-catalog.dbConnectionString" -}}
{{- $pg := .Values.dependencies.postgresql -}}
{{- printf "postgres://%s:%s@%s/%s?sslmode=%s" $pg.user $pg.password $pg.host $pg.database $pg.sslMode -}}
{{- end }}
