import React, { createContext, useContext, useEffect, useState } from "react";
import mqtt, { IClientOptions } from "mqtt";
import { MQTT_URL, MQTT_USER, MQTT_PASSWORD, MQTT_TOPICS } from "../config";

interface MqttContextType {
  client: mqtt.MqttClient | null;
  publish: (topic: string, message: string) => void;
  isConnected: boolean;
  hasError: boolean;
  errors: string[];
  connect: (url: string, username: string, password: string) => void;
  isConnecting: boolean;
}

const MqttContext = createContext<MqttContextType>({
  client: null,
  publish: () => {},
  isConnected: false,
  hasError: false,
  errors: [],
  connect: () => {},
  isConnecting: false,
});

export const useMqtt = () => useContext(MqttContext);

export const MqttProvider: React.FC<{ children: React.ReactNode }> = ({
  children,
}) => {
  const [client, setClient] = useState<mqtt.MqttClient | null>(null);
  const [isConnected, setIsConnected] = useState<boolean>(false);
  const [isConnecting, setIsConnecting] = useState<boolean>(false);
  const [hasError, setHasError] = useState<boolean>(false);
  const [errors, setErrors] = useState<string[]>([]);

  useEffect(() => {
    connect(MQTT_URL, MQTT_USER, MQTT_PASSWORD); // Connect with default values on load
  }, []);

  const connect = (url: string, username: string, password: string) => {
    const options: IClientOptions = {
      username: username,
      password: password,
    };

    if (url) {
      setIsConnected(false);
      setErrors([]);
      setHasError(false);
      setIsConnecting(true);

      const mqttClient = mqtt.connect(url, options);
      setClient(mqttClient);

      mqttClient.on("connect", () => {
        setIsConnected(true);
        setHasError(false);
        setIsConnecting(false);
        setErrors([]);
        for (let topic of MQTT_TOPICS) {
          console.log("subscribing to", topic);
          mqttClient.subscribe(topic);
        }
      });

      mqttClient.on("disconnect", () => {
        setIsConnected(false);
      });

      mqttClient.on("error", (error: Error) => {
        setIsConnected(false);
        setIsConnecting(false);
        setHasError(true);
        setErrors((prevErrors) => [...prevErrors, error.message]);
      });

      return () => {
        setIsConnected(false);
        mqttClient.end();
      };
    }
  };

  const publish = (topic: string, message: string) => {
    if (client && client.connected) {
      client.publish(topic, message);
    }
  };

  return (
    <MqttContext.Provider
      value={{
        client,
        publish,
        isConnected,
        hasError,
        errors,
        connect,
        isConnecting,
      }}
    >
      {children}
    </MqttContext.Provider>
  );
};
