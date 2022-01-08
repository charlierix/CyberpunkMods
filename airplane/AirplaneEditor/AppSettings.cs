using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AirplaneEditor
{
    public sealed class AppSettings
    {
        public static readonly Lazy<AppSettings> _instance = new Lazy<AppSettings>(() => new AppSettings());

        private readonly object _lock;
        private readonly IConfiguration _config;

        private AppSettings()
        {
            _lock = new object();

            _config = new ConfigurationBuilder().
                AddJsonFile("appsettings.json", false, true).
                Build();
        }

        public static double Density_Fuselage => Get_Float("density_fuselage");
        public static double Density_Wing => Get_Float("density_wing");
        public static double Density_Engine => Get_Float("density_engine");
        public static double Density_Bomb => Get_Float("density_bomb");
        public static double Density_Gun => Get_Float("density_gun");

        public static double Wing_Thickness => Get_Float("wing_thickness");

        public static double Engine_Radius => Get_Float("engine_radius");

        public static double Bomb_Length => Get_Float("bomb_length");
        public static double Bomb_Radius => Get_Float("bomb_radius");

        public static double Gun_Length => Get_Float("gun_length");
        public static double Gun_Radius => Get_Float("gun_radius");

        public static double Gravity => Get_Float("gravity");

        public static double Get_Float(string key)
        {
            AppSettings instance = _instance.Value;

            lock (instance._lock)
            {
                string value = instance._config[key];

                if (double.TryParse(value ?? "", out double cast))
                    return cast;
                else
                    throw new ApplicationException($"appsettings key not found: {key}");
            }
        }
    }
}
