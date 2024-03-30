import React, { createContext, useContext, useEffect, useState } from "react";
import mqtt, { IClientOptions } from "mqtt";
import { MQTT_URL, MQTT_USER, MQTT_PASSWORD, MQTT_TOPICS } from "../config";

interface MqttContextType {
  client: mqtt.MqttClient | null;
  publish: (topic: string, message: string) => void;
  isConnected: boolean;
}

const MqttContext = createContext<MqttContextType>({
  client: null,
  publish: () => {},
  isConnected: false,
});

export const useMqtt = () => useContext(MqttContext);

export const MqttProvider: React.FC<{ children: React.ReactNode }> = ({
  children,
}) => {
  const [client, setClient] = useState<mqtt.MqttClient | null>(null);
  const [isConnected, setIsConnected] = useState<boolean>(false);

  useEffect(() => {
    const options: IClientOptions = {
      username: MQTT_USER,
      password: MQTT_PASSWORD,
    };

    if (MQTT_URL) {
      const mqttClient = mqtt.connect(MQTT_URL, options);
      setClient(mqttClient);

      mqttClient.on("connect", () => {
        setIsConnected(true);
        for (let topic of MQTT_TOPICS) {
          console.log("subscribing to", topic);
          mqttClient.subscribe(topic);
        }
      });

      mqttClient.on("disconnect", () => {
        setIsConnected(false);
      });

      return () => {
        setIsConnected(false);
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
    <MqttContext.Provider value={{ client, publish, isConnected }}>
      {children}
    </MqttContext.Provider>
  );
};
