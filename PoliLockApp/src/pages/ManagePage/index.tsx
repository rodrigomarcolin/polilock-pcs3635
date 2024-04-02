import {
  IonContent,
  IonHeader,
  IonPage,
  IonTitle,
  IonToolbar,
} from "@ionic/react";

import { useMqtt } from "../../contexts/MqttContext";
import { useEffect } from "react";

import ModifyPasswordForm from "./ModifyPasswordForm";
import StateList from "./StateList";
import LogsCard from "./LogsCard";

const ManagePage: React.FC = () => {
  const { client } = useMqtt();

  const onMessage = (topic: string, payload: any) => {
    console.log("received", payload, "on", topic);
  };

  useEffect(() => {
    client?.on("message", onMessage);

    // Clean up function
    return () => {
      client?.removeListener("message", onMessage);
    };
  }, []);

  return (
    <IonPage>
      <IonHeader>
        <IonToolbar>
          <IonTitle>Gerenciar Armário</IonTitle>
        </IonToolbar>
      </IonHeader>
      <IonContent className={"ion-padding ion-margin"} fullscreen>
        <IonHeader collapse="condense">
          <IonToolbar>
            <IonTitle size="large">Gerenciar Armário</IonTitle>
          </IonToolbar>
        </IonHeader>

        <ModifyPasswordForm />
        <StateList />
        <LogsCard />
      </IonContent>
    </IonPage>
  );
};

export default ManagePage;
