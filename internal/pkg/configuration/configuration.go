package configuration

import (
	"time"

	"github.com/spf13/viper"
)

const (
	development = "development"
)

var config = new(configuration)

// Init initialize configuration
func Init() error {
	v := viper.New()

	if err := setEnvsBindings(v); err != nil {
		return err
	}

	err := v.Unmarshal(config)

	return err
}

type configuration struct {
	Environment     string        `mapstructure:"env"`
	Bind            string        `mapstructure:"bind"`
	DebugBind       string        `mapstructure:"debug_bind"`
	MetricsBind     string        `mapstructure:"metrics_bind"`
	GracefulTimeout time.Duration `mapstructure:"graceful_timeout"`
}

func setEnvsBindings(v *viper.Viper) error {
	v.SetEnvPrefix("server")
	for env, def := range map[string]interface{}{
		"env":              "development",
		"bind":             "0.0.0.0:8080",
		"debug_bind":       "0.0.0.0:9090",
		"metrics_bind":     "0.0.0.0:9427",
		"graceful_timeout": 5 * time.Second,
	} {
		if err := v.BindEnv(env); err != nil {
			return err
		}
		v.SetDefault(env, def)
	}

	return nil
}

// Environment current mode
func Environment() string {
	return config.Environment
}

// Bind web server address
func Bind() string {
	return config.Bind
}

// DebugBind debug server address
func DebugBind() string {
	return config.DebugBind
}

// MetricsBind metrics server address
func MetricsBind() string {
	return config.MetricsBind
}

// IsDevelopment dev-mode?
func IsDevelopment() bool {
	return config.Environment == development
}

// GracefulTimeout for shutdown
func GracefulTimeout() time.Duration {
	return config.GracefulTimeout
}
