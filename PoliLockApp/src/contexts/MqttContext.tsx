import React, { createContext, useContext, useEffect, useState } from "react";
import mqtt, { IClientOptions } from "precompiled-mqtt";
import { MQTT_URL, MQTT_USER, MQTT_PASSWORD, MQTT_TOPICS, getMqttTopic } from "../config";

interface MqttContextType {
  client: mqtt.MqttClient | null;
  publish: (topic: string, message: string) => void;
  isConnected: boolean;
  hasError: boolean;
  errors: string[];
  connect: (url: string, username: string, password: string) => void;
  isConnecting: boolean;
  isBlocked: boolean;
  isLocked: boolean;
}

const MqttContext = createContext<MqttContextType>({
  client: null,
  publish: () => { },
  isConnected: false,
  hasError: false,
  errors: [],
  connect: () => { },
  isConnecting: false,
  isBlocked: false,
  isLocked: false
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
  const [isLocked, setIsLocked] = useState<boolean>(false);
  const [isBlocked, setIsBlocked] = useState<boolean>(false);

  const lockedTopic = getMqttTopic("locked");
  const blockedTopic = getMqttTopic("blocked");

  useEffect(() => {
    connect(MQTT_URL, MQTT_USER, MQTT_PASSWORD); // Connect with default values on load
  }, []);

  const updateStateOnMessage = (topic: string, message: any) => {
    console.log(`received ${message.toString()} on topic ${topic}`)
    let msg = (message.toString());

    switch (topic) {
      case blockedTopic:
        setIsBlocked(msg === "blocked");
        break;
      case lockedTopic:
        setIsLocked(msg === "locked");
        break;
    }
  }

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

      mqttClient.on("message", updateStateOnMessage);
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
        isBlocked,
        isLocked
      }}
    >
      {children}
    </MqttContext.Provider>
  );
};
