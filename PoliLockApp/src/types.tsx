export interface StatusRepresentation {
  name: string;
  icon: any;
  color: string;
}
export interface StatusToRepresentationMap {
  [key: string]: StatusRepresentation;
}

export interface StatusIndicatorInterface {
  statusToRep: StatusToRepresentationMap;
  status: string;
  iconSize: "large" | "small";
}
