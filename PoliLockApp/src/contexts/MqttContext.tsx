import React, { createContext, useContext, useEffect, useState } from "react";
import mqtt, { IClientOptions } from "mqtt";

interface MqttContextType {
  client: mqtt.MqttClient | null;
  publish: (topic: string, message: string) => void;
}

const MqttContext = createContext<MqttContextType>({
  client: null,
  publish: () => {},
});

export const useMqtt = () => useContext(MqttContext);

export const MqttProvider: React.FC<{ children: React.ReactNode }> = ({
  children,
}) => {
  const [client, setClient] = useState<mqtt.MqttClient | null>(null);
  const port = import.meta.env.REACT_APP_MQTT_PORT
    ? parseInt(import.meta.env.REACT_APP_MQTT_PORT)
    : undefined;

  useEffect(() => {
    const url = import.meta.env.REACT_APP_MQTT_BROKER_URL;
    const options: IClientOptions = {
      username: import.meta.env.REACT_APP_MQTT_USERNAME,
      password: import.meta.env.REACT_APP_MQTT_PASSWORD,
      port: port,
    };

    if (url) {
      const mqttClient = mqtt.connect(url, options);
      setClient(mqttClient);

      return () => {
        mqttClient.end();
      };
    }
  }, []);

  const publish = (topic: string, message: string) => {
    if (client) {
      client.publish(topic, message);
    }
  };

  return (
    <MqttContext.Provider value={{ client, publish }}>
      {children}
    </MqttContext.Provider>
  );
};
