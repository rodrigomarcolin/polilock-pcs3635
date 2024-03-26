import React from "react";
import { IonIcon } from "@ionic/react";
import { wifi, airplane } from "ionicons/icons";

interface ConnectionIndicatorProps {
  isConnected: boolean | undefined;
}

const ConnectionIndicator: React.FC<ConnectionIndicatorProps> = ({
  isConnected,
}) => {
  return (
    <span style={{ display: "flex", alignItems: "center" }}>
      <IonIcon
        size="large"
        icon={isConnected ? wifi : airplane}
        color={isConnected ? "success" : "danger"}
      />
    </span>
  );
};

export default ConnectionIndicator;
