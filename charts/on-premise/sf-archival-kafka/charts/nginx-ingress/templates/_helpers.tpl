{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "nginx-ingress.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "nginx-ingress.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "nginx-ingress.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified controller name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "nginx-ingress.controller.fullname" -}}
{{- printf "%s-%s" (include "nginx-ingress.fullname" .) "controller" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified exporter name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "nginx-ingress.exporter.fullname" -}}
{{- printf "%s-%s" (include "nginx-ingress.fullname" .) "exporter" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Construct the path for the publish-service.

By convention this will simply use the <namespace>/<controller-name> to match the name of the
service generated.

Users can provide an override for an explicit service they want bound via `.Values.controller.publishService.pathOverride`

*/}}
{{- define "nginx-ingress.controller.publishServicePath" -}}
{{- $defServiceName := printf "%s/%s" "$(POD_NAMESPACE)" (include "nginx-ingress.controller.fullname" .) -}}
{{- $servicePath := default $defServiceName .Values.controller.publishService.pathOverride }}
{{- print $servicePath | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified default backend name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "nginx-ingress.defaultBackend.fullname" -}}
{{- printf "%s-%s" (include "nginx-ingress.fullname" .) "defaultbackend" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "nginx-ingress.labels" -}}
helm.sh/chart: {{ include "nginx-ingress.chart" . }}
{{ include "nginx-ingress.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "nginx-ingress.selectorLabels" -}}
app.kubernetes.io/name: {{ include "nginx-ingress.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Create the name of the controller service account to use
*/}}
{{- define "nginx-ingress.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "nginx-ingress.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the backend service account to use - only used when podsecuritypolicy is also enabled
*/}}
{{- define "nginx-ingress.defaultBackend.serviceAccountName" -}}
{{- if .Values.defaultBackend.serviceAccount.create -}}
    {{ default (printf "%s-backend" (include "nginx-ingress.fullname" .)) .Values.defaultBackend.serviceAccount.name }}
{{- else -}}
    {{ default "default-backend" .Values.defaultBackend.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Return the appropriate apiGroup for PodSecurityPolicy.
*/}}
{{- define "podSecurityPolicy.apiGroup" -}}
{{- if semverCompare ">=1.14-0" .Capabilities.KubeVersion.GitVersion -}}
{{- print "policy" -}}
{{- else -}}
{{- print "extensions" -}}
{{- end -}}
{{- end -}}

{{/*
Check the ingress controller version tag is at most three versions behind the last release
*/}}
{{- define "isControllerTagValid" -}}
{{- if not (semverCompare ">=0.27.0-0" .Values.controller.image.tag) -}}
{{- fail "Controller container image tag should be 0.27.0 or higher" -}}
{{- end -}}
{{- end -}}
