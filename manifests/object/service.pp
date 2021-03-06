# == Define: icinga2::object::service
#
# Manage Icinga2 service objects.
#
# === Parameters
#
# [*ensure*]
#   Set to present enables the object, absent disables it. Defaults to present.
#
# [*display_name*]
#   A short description of the service.
#
# [*host_name*]
#   The host this service belongs to. There must be a Host object with
#   that name.
#
# [*name*]
#   The service name. Must be unique on a per-host basis (Similar to the
#   service_description attribute in Icinga 1.x).
#
# [*groups*]
#   The service groups this service belongs to.
#
# [*vars*]
#   A dictionary containing custom attributes that are specific to this service.
#
# [*check_command*]
#   The name of the check command.
#
# [*max_check_attempts*]
#   The number of times a service is re-checked before changing into a hard
#   state. Defaults to 3.
#
# [*check_period*]
#   The name of a time period which determines when this service should be
#   checked. Not set by default.
#
# [*check_timeout*]
#   Check command timeout in seconds. Overrides the CheckCommand's timeout
#   attribute.
#
# [*check_interval*]
#   The check interval (in seconds). This interval is used for checks when the
#   service is in a HARD state. Defaults to 5 minutes.
#
# [*retry_interval*]
#   The retry interval (in seconds). This interval is used for checks when the
#   service is in a SOFT state. Defaults to 1 minute.
#
# [*enable_notifications*]
#   Whether notifications are enabled. Defaults to true.
#
# [*enable_active_checks*]
#   Whether active checks are enabled. Defaults to true.
#
# [*enable_passive_checks*]
#   Whether passive checks are enabled. Defaults to true.
#
# [*enable_event_handler*]
#   Enables event handlers for this host. Defaults to true.
#
# [*enable_flapping*]
#   Whether flap detection is enabled. Defaults to false.
#
# [*enable_perfdata*]
#   Whether performance data processing is enabled. Defaults to true.
#
# [*event_command*]
#   The name of an event command that should be executed every time the
#   service's state changes or the service is in a SOFT state.
#
# [*flapping_threshold*]
#   The flapping threshold in percent when a service is considered to be
#   flapping.
#
# [*volatile*]
#   The volatile setting enables always HARD state types if NOT-OK state changes
#   occur.
#
# [*zone*]
#   The zone this object is a member of.
#
# [*command_endpoint*]
#   The endpoint where commands are executed on.
#
# [*notes*]
#   Notes for the service.
#
# [*notes_url*]
#   Url for notes for the service (for example, in notification commands).
#
# [*action_url*]
#   Url for actions for the service (for example, an external graphing tool).
#
# [*icon_image*]
#   Icon image for the service. Used by external interfaces only.
#
# [*icon_image_alt*]
#   Icon image description for the service. Used by external interface only.
#
# [*template*]
#   Set to true creates a template instead of an object. Defaults to false.
#
# [*apply*]
#   Dispose an apply instead an object if set to 'true'. Value is taken as statement,
#   i.e. 'vhost => config in host.vars.vhosts'. Defaults to false.
#
# [*assign*]
#   Assign user group members using the group assign rules.
#
# [*ignore*]
#   Exclude users using the group ignore rules.
#
# [*import*]
#   Sorted List of templates to include. Defaults to an empty list.
#
# [*target*]
#   Destination config file to store in this object. File will be declared the
#   first time.
#
# [*order*]
#   String to set the position in the target file, sorted alpha numeric. Defaults to 10.
#
# === Authors
#
# Alessandro Lorenzi <alessandro@lm-net.it>
# Icinga Development Team <info@icinga.org>
#

define icinga2::object::service (
  $ensure                 = present,
  $display_name           = undef,
  $host_name              = undef,
  $groups                 = undef,
  $vars                   = {},
  $check_command          = undef,
  $max_check_attempts     = undef,
  $check_period           = undef,
  $check_timeout          = undef,
  $check_interval         = undef,
  $retry_interval         = undef,
  $enable_notifications   = undef,
  $enable_active_checks   = undef,
  $enable_passive_checks  = undef,
  $enable_event_handler   = undef,
  $enable_flapping        = undef,
  $enable_perfdata        = undef,
  $event_command          = undef,
  $flapping_threshold     = undef,
  $volatile               = undef,
  $zone                   = undef,
  $command_endpoint       = undef,
  $notes                  = undef,
  $notes_url              = undef,
  $action_url             = undef,
  $icon_image             = undef,
  $icon_image_alt         = undef,
  $apply                  = false,
  $assign                 = [],
  $ignore                 = [],
  $import                 = [],
  $template               = false,
  $target                 = undef,
  $order                  = '10',
) {

  include ::icinga2::params

  $conf_dir = $::icinga2::params::conf_dir

  # validation
  validate_re($ensure, [ '^present$', '^absent$' ],
    "${ensure} isn't supported. Valid values are 'present' and 'absent'.")
  unless is_bool($apply) { validate_string($apply) }
  validate_array($import)
  validate_bool($template)
  validate_absolute_path($target)
  validate_string($order)

  if $display_name { validate_string ($display_name) }
  validate_string($host_name)
  if $groups { validate_array ($groups) }
  if $vars { validate_hash ($vars) }
  validate_string($check_command)
  if $max_check_attempts { validate_integer ($max_check_attempts) }
  if $check_period { validate_integer ($check_period) }
  if $check_timeout { validate_integer ($check_timeout) }
  if $check_interval { validate_integer ($check_interval) }
  if $retry_interval { validate_integer ($retry_interval) }
  if $enable_notifications { validate_bool ($enable_notifications) }
  if $enable_active_checks { validate_bool ($enable_active_checks) }
  if $enable_passive_checks { validate_bool ($enable_passive_checks) }
  if $enable_event_handler { validate_bool ($enable_event_handler) }
  if $enable_flapping { validate_bool ($enable_flapping) }
  if $enable_perfdata { validate_bool ($enable_perfdata) }
  if $event_command { validate_string ($event_command) }
  if $flapping_threshold { validate_integer ($flapping_threshold) }
  if $volatile { validate_bool ($volatile) }
  if $zone { validate_string ($zone) }
  if $command_endpoint { validate_string ($command_endpoint) }
  if $notes { validate_string ($notes) }
  if $notes_url { validate_string ($notes_url) }
  if $action_url { validate_string ($action_url) }
  if $icon_image { validate_absolute_path ($icon_image) }
  if $icon_image_alt { validate_string ($icon_image_alt) }


  # compose the attributes
  $attrs = {
    'display_name' => $display_name ,
    'host_name' => $host_name ,
    'name' => $name ,
    'groups' => $groups ,
    'vars' => $vars ,
    'check_command' => $check_command ,
    'max_check_attempts' => $max_check_attempts ,
    'check_period' => $check_period ,
    'check_timeout' => $check_timeout ,
    'check_interval' => $check_interval ,
    'retry_interval' => $retry_interval ,
    'enable_notifications' => $enable_notifications ,
    'enable_active_checks' => $enable_active_checks ,
    'enable_passive_checks' => $enable_passive_checks ,
    'enable_event_handler' => $enable_event_handler ,
    'enable_flapping' => $enable_flapping ,
    'enable_perfdata' => $enable_perfdata ,
    'event_command' => $event_command ,
    'flapping_threshold' => $flapping_threshold ,
    'volatile' => $volatile ,
    'zone' => $zone ,
    'command_endpoint' => $command_endpoint ,
    'notes' => $notes ,
    'notes_url' => $notes_url ,
    'action_url' => $action_url ,
    'icon_image' => $icon_image ,
    'icon_image_alt' => $icon_image_alt ,
  }

  # create object
  icinga2::object { "icinga2::object::Service::${title}":
    ensure       => $ensure,
    object_name  => $name,
    object_type  => 'Service',
    import       => $import,
    apply        => $apply,
    apply_target => 'Host',
    assign       => $assign,
    ignore       => $ignore,
    template     => $template,
    attrs        => $attrs,
    target       => $target,
    order        => $order,
    notify       => Class['::icinga2::service'],
  }
}
