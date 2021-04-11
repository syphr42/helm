{{/*
Expand the name of the chart.
*/}}
{{- define "wekan.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "wekan.fullname" -}}
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

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "wekan.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "wekan.labels" -}}
helm.sh/chart: {{ include "wekan.chart" . }}
{{ include "wekan.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "wekan.selectorLabels" -}}
app.kubernetes.io/name: {{ include "wekan.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "wekan.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "wekan.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Detetermine the MongoDB URL
*/}}
{{- define "wekan.mongoDbUrlEnvValue" -}}
{{- if .Values.config.mongodb.urlSecretName }}
valueFrom:
  secretKeyRef:
    name: {{ .Values.config.mongodb.urlSecretName }}
    key: {{ default "mongodb-url" .Values.config.mongodb.urlSecretKey }}
{{- else }}
value: {{ .Values.config.mongodb.url | quote }}
{{- end }}
{{- end }}

{{/*
Detetermine the MongoDB Op Log URL
*/}}
{{- define "wekan.mongoDbOpLogUrlEnvValue" -}}
{{- if .Values.config.mongodb.opLogUrlSecretName }}
valueFrom:
  secretKeyRef:
    name: {{ .Values.config.mongodb.opLogUrlSecretName }}
    key: {{ default "mongodb-url-oplog" .Values.config.mongodb.opLogUrlSecretKey }}
{{- else }}
value: {{ .Values.config.mongodb.opLogUrl | quote }}
{{- end }}
{{- end }}
