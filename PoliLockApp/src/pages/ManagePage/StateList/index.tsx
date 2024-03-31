import {
  IonCard,
  IonCardContent,
  IonCardHeader,
  IonCardTitle,
  IonList,
  IonItem,
  IonLabel,
} from "@ionic/react";

import StatusIndicator from "../../../components/StatusIndicator";
import { useMqtt } from "../../../contexts/MqttContext";
import { getMqttTopic } from "../../../config";
import { StatusToRepresentationMap } from "../../../types";
import {
  closeCircle,
  checkmarkCircle,
  lockClosed,
  lockOpen,
} from "ionicons/icons";
import { useEffect, useState } from "react";

const StateList: React.FC = () => {
  const { client } = useMqtt();

  const [lockedStatus, setLockedStatus] = useState<string>("locked");
  const [blockedStatus, setBlockedStatus] = useState<string>("unblocked");

  const lockedTopic = getMqttTopic("locked");
  const blockedTopic = getMqttTopic("blocked");

  const handleIncomingMessages = (topic: string, message: any) => {
    console.log("Agora o armário está", message.toString());

    switch (topic) {
      case blockedTopic:
        setBlockedStatus(message.toString());
        break;
      case lockedTopic:
        setLockedStatus(message.toString());
        break;
    }
  };

  useEffect(() => {
    client?.on("message", handleIncomingMessages);

    // Clean up function
    return () => {
      client?.removeListener("message", handleIncomingMessages);
    };
  }, []);

  const blockedStatusRep: StatusToRepresentationMap = {
    blocked: {
      color: "danger",
      name: "Bloqueado",
      icon: closeCircle,
    },
    unblocked: {
      color: "success",
      name: "Não bloqueado",
      icon: checkmarkCircle,
    },
  };

  const lockedStatusRep: StatusToRepresentationMap = {
    locked: {
      color: "danger",
      name: "Trancado",
      icon: lockClosed,
    },
    unlocked: {
      color: "success",
      name: "Destrancado",
      icon: lockOpen,
    },
  };

  return (
    <IonCard>
      <IonCardHeader>
        <IonCardTitle>Armário</IonCardTitle>
      </IonCardHeader>

      <IonCardContent>
        <IonList>
          <IonItem>
            <StatusIndicator
              iconSize="large"
              status={lockedStatus}
              defaultStatus="locked"
              statusToRep={lockedStatusRep}
            />
          </IonItem>
          <IonItem>
            <StatusIndicator
              iconSize="large"
              status={blockedStatus}
              defaultStatus="unblocked"
              statusToRep={blockedStatusRep}
            />
          </IonItem>
        </IonList>
      </IonCardContent>
    </IonCard>
  );
};

export default StateList;
