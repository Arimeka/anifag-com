package postgres

import (
	"fmt"
	"sync"
	"time"

	// Initialize postgresql adapter
	_ "github.com/jinzhu/gorm/dialects/postgres"

	"github.com/Arimeka/anifag-com/internal/pkg/configuration"

	"github.com/jinzhu/gorm"
	"github.com/spf13/viper"
)

const (
	defaultDatabaseConnectTimeout = 5
)

var (
	client *gorm.DB
	mutex  = &sync.Mutex{}
)

// Client return gorm client
// Lazy initialize gorm client
func Client() (*gorm.DB, error) {
	mutex.Lock()
	defer mutex.Unlock()

	if client != nil {
		return client, nil
	}

	if err := connect(); err != nil {
		return nil, err
	}

	return client, nil
}

func connect() error {

	opts, err := connectionOptions()
	if err != nil {
		return err
	}

	client, err = gorm.Open("postgres", opts.connArgs())
	if err != nil {
		return err
	}

	if configuration.IsDevelopment() {
		client.LogMode(true)
	}

	driver := client.DB()
	driver.SetMaxOpenConns(opts.MaxOpenConns)
	driver.SetMaxIdleConns(opts.MaxIdleConns)
	driver.SetConnMaxLifetime(opts.ConnTTL)

	return err
}

type options struct {
	User           string `mapstructure:"username"`
	Password       string `mapstructure:"password"`
	Database       string `mapstructure:"name"`
	Host           string `mapstructure:"host"`
	Port           string `mapstructure:"port"`
	SSLMode        string `mapstructure:"sslmode"`
	ConnectTimeout int    `mapstructure:"connect_timeout"`

	MaxOpenConns int           `mapstructure:"max_open_conns"`
	MaxIdleConns int           `mapstructure:"max_idle_conns"`
	ConnTTL      time.Duration `mapstructure:"conn_ttl"`
}

func (opts *options) connArgs() string {
	var result string

	if opts.User != "" {
		result = fmt.Sprintf("%s %s='%s'", result, "user", opts.User)
	}

	if opts.Password != "" {
		result = fmt.Sprintf("%s %s='%s'", result, "password", opts.Password)
	}

	if opts.Database != "" {
		result = fmt.Sprintf("%s %s='%s'", result, "dbname", opts.Database)
	}

	if opts.Host != "" {
		result = fmt.Sprintf("%s %s='%s'", result, "host", opts.Host)
	}

	if opts.Port != "" {
		result = fmt.Sprintf("%s %s='%s'", result, "port", opts.Port)
	}

	if opts.SSLMode != "" {
		result = fmt.Sprintf("%s %s='%s'", result, "sslmode", opts.SSLMode)
	}

	if opts.ConnectTimeout <= 0 {
		opts.ConnectTimeout = defaultDatabaseConnectTimeout
	}

	result = fmt.Sprintf("%s %s='%d'", result, "connect_timeout", opts.ConnectTimeout)

	return result
}

func connectionOptions() (*options, error) {
	v := viper.New()
	v.SetEnvPrefix("PG")

	for env, def := range map[string]interface{}{
		"username":        "anifag_dev",
		"password":        "anifag_dev",
		"name":            "anifag_dev",
		"host":            "127.0.0.1",
		"port":            "5433",
		"sslmode":         "disable",
		"connect_timeout": defaultDatabaseConnectTimeout,
		"max_open_conns":  5,
		"max_idle_conns":  10,
		"conn_ttl":        "60s",
	} {
		if err := v.BindEnv(env); err != nil {
			return nil, err
		}
		v.SetDefault(env, def)
	}

	opts := &options{}
	if err := v.Unmarshal(opts); err != nil {
		return opts, err
	}

	return opts, nil
}
